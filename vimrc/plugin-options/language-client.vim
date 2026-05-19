" LanguageClient-neovim is not installed — these settings are inactive.
" Kept as reference for potential future use.
finish

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
    \     'python': ['pylsp'],
    \     'rust': ['rust-analyzer'],
    \     'javascript': ['typescript-language-server', '--stdio'],
    \     'javascript.jsx': ['typescript-language-server', '--stdio'],
    \ }

let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_hoverPreview = 'Never'
let g:LanguageClient_autoStart = 0
