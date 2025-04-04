import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs";
import { D2 } from 'https://esm.sh/@terrastruct/d2';

document.addEventListener("DOMContentLoaded", () => {
    const d2 = new D2();

    // 공통 원본 코드 보기 추가 함수
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

    // Mermaid 다이어그램 렌더링
    document.querySelectorAll("pre > code.language-mermaid").forEach(async (block) => {
        const originalCode = block.textContent;

        // Mermaid SVG로 교체
        await mermaid.init(undefined, block);

        const svgElement = block.querySelector('svg');  // svg 요소 찾기
        svgElement.classList.add("diagram");  // className을 'diagram'으로 변경
        const meDiagram = document.createElement('div');
        // meDiagram.className = 'svg-container';  // 확대된 SVG를 담을 컨테이너
        meDiagram.appendChild(svgElement);

        const parentNode = block.parentElement;
        parentNode.parentNode.insertBefore(meDiagram, parentNode);
        parentNode.remove();

        addSourceCodeButton(meDiagram, originalCode); // 공통 함수로 원본 보기 추가

        triggerRenderEvent();
    });

    // D2 다이어그램 렌더링
    async function renderDiagram(d2Code, block) {
        const result = await d2.compile(d2Code, { layout: "elk" });

        // layout 옵션을 올바르게 적용
        const svg = await d2.render(result.diagram);

        // 다이어그램을 `pre > code.language-d2` 바로 아래에 삽입
        const d2Diagram = document.createElement('div');
        d2Diagram.className = 'svg-container';  // 확대된 SVG를 담을 컨테이너
        d2Diagram.innerHTML = svg;

        const parentNode = block.parentElement;
        parentNode.parentNode.insertBefore(d2Diagram, parentNode);
        parentNode.remove();

        const svgElement = d2Diagram.querySelector('svg');  // svg 요소 찾기
        if (svgElement) {
            svgElement.classList.add("diagram");  // className을 'diagram'으로 변경
        }

        addSourceCodeButton(d2Diagram, d2Code); // 공통 함수로 원본 보기 추가

        triggerRenderEvent();
    }

    // 최초 다이어그램 렌더링 (D2 및 Mermaid 모두)
    document.querySelectorAll("pre > code.language-d2").forEach(async (block) => {
        const d2Code = block.textContent;
        await renderDiagram(d2Code, block);
    });

    document.querySelectorAll("code.language-tree").forEach(async (block) => {
        const treeText = block.textContent;
        const output = treeTextToDOM(treeText);
        console.log(output);
        block.parentElement.appendChild(output);
        block.remove();
    });
});

// 이미지 클릭 시 확대 뷰 보여주기
function addSvgClickEventListener() {
    document.querySelectorAll('div.svg-container').forEach(container => {
        console.log("rendered");

        // 클릭 시 클래스 토글
        if (container.setEvent != true) {
            container.addEventListener('click', function () {
                // SVG 확대/축소 및 부모 컨테이너 크기 변경            
                container.classList.toggle('enlarged-svg-container');
                container.querySelector("svg.diagram").classList.toggle('enlarged');
            });
        };
        container.setEvent = true;
    });
}

// 다이어그램이나 콘텐츠가 동적으로 추가된 경우, 이미지 클릭 이벤트 리스너 추가
document.addEventListener('rendered', () => {
    addSvgClickEventListener();  // 동적으로 추가된 이미지에 대한 클릭 이벤트 추가
});

// 예시: 다이어그램이나 콘텐츠 렌더링 후 'rendered' 이벤트를 트리거
function triggerRenderEvent() {
    const event = new Event('rendered');
    document.dispatchEvent(event);
}

function treeTextToDOM(treeText) {
    const lines = treeText
        .split("\n")
        .filter((line) => line.trim() !== "")
        .map((line) => {
            const match = line.match(/^([│\s]*)([├└]── )?(.*)$/)
            const depth = (match[1].match(/│|    /g) || []).length
            const name = match[3].trim()
            return { depth, name }
        })

    const root = document.createElement("div")
    const stack = [{ depth: -1, element: root }]

    for (const { depth, name } of lines) {
        const isFile = /\.[a-z0-9]+$/i.test(name)

        const div = document.createElement("div")
        div.className = "tree-item"
        div.textContent = `${isFile ? "📄" : "📁"} ${name}`

        while (stack.length && stack[stack.length - 1].depth >= depth) {
            stack.pop()
        }

        const parent = stack[stack.length - 1].element
        parent.appendChild(div)
        stack.push({ depth, element: div })
    }

    return root;
}
