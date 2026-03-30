" Enable diagnostics highlighting
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

" LSP servers
let lspServers = [
      \ #{
      \   name: 'rust-analyzer',
      \   filetype: ['rust'],
      \   path: 'rust-analyzer',
      \   args: []
      \ },
      \ #{
      \   name: 'gopls',
      \   filetype: ['go', 'gomod', 'gowork'],
      \   path: 'gopls',
      \   args: []
      \ }
      \ ]

autocmd User LspSetup call LspAddServer(lspServers)

" Key mappings
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>

" Completion (ALL languages, not just one)
autocmd FileType * setlocal omnifunc=lsp#complete
inoremap <silent> <C-Space> <C-x><C-o>

" Formatting (safe ones)
autocmd BufWritePre *.go LspDocumentFormatSync
autocmd BufWritePre *.rs LspDocumentFormatSync

" Diagnostic signs
autocmd User LspSetup call LspOptionsSet(#{
    \ diagSignErrorText: '✘',
    \ diagSignWarningText: '▲',
    \ diagSignInfoText: '»',
    \ diagSignHintText: '⚑',
    \ })
