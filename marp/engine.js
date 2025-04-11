const { Marp } = require('@marp-team/marp-core')
const markdownItMark = require('markdown-it-mark')

class MyEngine extends Marp {
  render(markdown, opts = {}) {
    const rendered = super.render(markdown, opts)
    const headScript = `
      <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
      <script>mermaid.initialize({ 
        startOnLoad: true,
        theme: "base",
        themeVariables: {
          fontSize: '24px',
          fontFamily: 'Noto Sans KR, sans-serif',
          
          primaryColor: '#BB2649',         // 노드 배경색 (주요 컬러)
          primaryTextColor: '#ffffff',     // 노드 내부 텍스트 색상
          primaryBorderColor: '#992040',   // 노드 테두리 색상

          lineColor: '#BB2649',            // 화살표 선 색상
          textColor: '#0A2540',            // 전체 다이어그램 텍스트 기본 색상

          edgeLabelBackground: '#fff0f5',  // 화살표 텍스트 배경
          tertiaryColor: '#fbe9ee',        // 흐림 처리되는 박스 색 (예: subgraph)

          clusterBkg: '#fbe9ee',           // subgraph 배경
          clusterBorder: '#BB2649',

          actorBorder: '#BB2649',          // 시퀀스 다이어그램 요소
          actorBkg: '#fbe9ee',
          actorTextColor: '#BB2649',

          noteBkgColor: '#fff0f5',         // note (메모 박스) 색
          noteTextColor: '#0A2540'
        }
        });
      </script>
    `
    const fullHtml = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8" />
        <title>${opts.title || 'Marp Slide'}</title>
        <style>${rendered.css}</style>
        ${headScript}
      </head>
      <body>
        ${rendered.html}
      </body>
      </html>
    `
    return { html: fullHtml }
  }
}

module.exports = opts => new MyEngine(opts).use(markdownItMark)
