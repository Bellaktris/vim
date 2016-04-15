if !exists('g:lsp_servers') || empty(g:lsp_servers) || !has('nvim-0.11')
  finish
endif

nmap <silent> <leader>cp :execute 'Telescope find_files cwd='.helpers#find_git_root()<cr>

xnoremap <silent> <leader>ag "zy:execute 'Telescope live_grep cwd='.helpers#find_git_root().' default_text='.escape(@z, ' ')<cr>
xnoremap <silent> <leader>gp "zy:execute 'Telescope live_grep default_text='.escape(@z, ' ')<cr>

nmap <leader>ag :execute 'Telescope live_grep cwd='.helpers#find_git_root()<cr>
nmap <leader>gp :execute 'Telescope live_grep'<cr>

lua << EOF
  function _G.lsp_jump_to_tab()
    local cur_buf = vim.api.nvim_get_current_buf()
    local visible = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      visible[vim.api.nvim_win_get_buf(win)] = true
    end

    vim.lsp.buf.definition({
      on_list = function(result)
        if not result or not result.items or #result.items == 0 then return end
        local item = result.items[1]
        local target = item.filename or item.bufnr and vim.api.nvim_buf_get_name(item.bufnr)
        if not target then return end

        local lnum = item.lnum or 1
        local col = item.col or 1

        if target == vim.api.nvim_buf_get_name(cur_buf) then
          vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })
        else
          vim.cmd('tabedit +' .. lnum .. ' ' .. vim.fn.fnameescape(target))
          vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })
        end
      end,
    })
  end
EOF

