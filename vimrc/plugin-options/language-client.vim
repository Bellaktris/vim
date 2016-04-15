let g:LanguageClient_diagnosticsDisplay =
      \ {
      \   1: {
      \       "name": "Error",
      \       "texthl": "SyntasticError",
      \       "signText": "✘",
      \       "signTexthl": "SyntasticErrorSign",
      \   },
      \   2: {
      \       "name": "Warning",
      \       "texthl": "SyntasticWarning",
      \       "signText": "!",
      \       "signTexthl": "SyntasticWarningSign",
      \   },
      \   3: {
      \       "name": "Information",
      \       "texthl": "SyntasticWarning",
      \       "signText": "·",
      \       "signTexthl": "SyntasticWarningSign",
      \   },
      \   4: {
      \       "name": "Hint",
      \       "texthl": "SyntasticWarning",
      \       "signText": "·",
      \       "signTexthl": "SyntasticWarningSign",
      \   },
      \ }

let g:LanguageClient_serverCommands =
    \ {
    \     'python': ['/usr/local/bin/pyls'],
    \     'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \     'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \     'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ }

let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_hoverPreview = 'Never'
let g:LanguageClient_autoStart = 0
