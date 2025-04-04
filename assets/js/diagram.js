import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs";
import { D2 } from 'https://esm.sh/@terrastruct/d2';

// Mermaid 초기화
mermaid.initialize({ startOnLoad: true });

// DOMContentLoaded 시 전체 다이어그램 렌더링 처리
// 주요 흐름: Tree → Mermaid → D2 (렌더 순서 기준 아님, 기술/구문 분류 기준임)

document.addEventListener("DOMContentLoaded", () => {
    const d2 = new D2(); // D2 인스턴스 생성

    // 🔧 공통: 다이어그램 원본 보기 toggle 생성 함수
    function addSourceCodeButton(block, originalCode) {
        const details = document.createElement("details");
        const summary = document.createElement("summary");
        summary.innerText = "원본 보기";

        const pre = document.createElement("pre");
        const code = document.createElement("code");
        code.textContent = originalCode;

        details.appendChild(summary);
        details.appendChild(pre);
        pre.appendChild(code);

        block.parentElement.insertBefore(details, block);
    }

    // ✅ Mermaid 렌더링 처리
    document.querySelectorAll("pre > code.language-mermaid").forEach(async (block) => {
        const originalCode = block.textContent;

        // ⚠️ Mermaid는 className="mermaid" 인 엘리먼트만 렌더링 대상으로 인식함
        const mePre = document.createElement('pre');
        mePre.className = "mermaid"; // 반드시 class="mermaid" 이어야 렌더링됨
        mePre.innerHTML = originalCode;
        block.parentElement.insertBefore(mePre, block);

        addSourceCodeButton(mePre, originalCode);
        block.remove();

    });

    // ✅ D2 렌더링 처리
    async function renderDiagram(d2Code, block) {
        const result = await d2.compile(d2Code, { layout: "elk" });
        const svg = await d2.render(result.diagram);

        const d2Diagram = document.createElement('div');
        d2Diagram.className = 'svg-container'; // 📌 SVG용 외부 컨테이너
        d2Diagram.innerHTML = svg;

        const parentNode = block.parentElement;
        parentNode.parentNode.insertBefore(d2Diagram, parentNode);
        parentNode.remove();

        const svgElement = d2Diagram.querySelector('svg');
        if (svgElement) svgElement.classList.add("diagram"); // 확대용 class 추가

        addSourceCodeButton(d2Diagram, d2Code); // 원본 보기 추가
        handleRenderedElement(d2Diagram);
    }

    // ✅ D2 코드 탐색 후 렌더
    document.querySelectorAll("pre > code.language-d2").forEach(async (block) => {
        const d2Code = block.textContent;
        await renderDiagram(d2Code, block);
    });

    // ✅ Tree 구조 렌더링 처리
    document.querySelectorAll("code.language-tree").forEach(async (block) => {
        const treeText = block.textContent;
        const output = renderTreeTextToDOM(treeText);
        block.parentElement.appendChild(output);
        block.remove();
    });
});

// ✅ 렌더링된 요소 처리: 확대기능 부여
function handleRenderedElement(target) {
    if (!target || target.processedRender) return;
    target.processedRender = true;

    if (target.matches('div.svg-container')) {
        target.addEventListener('click', () => {
            target.classList.toggle('enlarged-svg-container');
            const svg = target.querySelector("svg.diagram");
            if (svg) svg.classList.toggle('enlarged');
        });
        target.setEvent = true;
    }

    target.dispatchEvent(new Event('rendered', { bubbles: true }));
}

// ✅ tree 텍스트 기반 트리 구조 DOM 생성
function renderTreeTextToDOM(treeText) {
    const lines = treeText
        .split("\n")
        .filter((line) => line.trim() !== "")
        .map((line) => {
            const match = line.match(/^([│\s]*)([├└]── )?(.*)$/);
            const depth = (match[1].match(/│|    /g) || []).length;
            const name = match[3].trim();
            return { depth, name };
        });

    const root = document.createElement("div");
    const stack = [{ depth: -1, element: root }];

    for (const { depth, name } of lines) {
        const isFile = /\.[a-z0-9]+$/i.test(name);
        const div = document.createElement("div");
        div.className = "tree-item";
        div.textContent = `${isFile ? "📄" : "📁"} ${name}`;

        while (stack.length && stack[stack.length - 1].depth >= depth) {
            stack.pop();
        }

        const parent = stack[stack.length - 1].element;
        parent.appendChild(div);
        stack.push({ depth, element: div });
    }

    return root;
}
