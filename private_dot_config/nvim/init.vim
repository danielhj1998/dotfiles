" Enable useful Vim functions (Disable Vi compatibility)
set nocompatible

"########################
"###### Vim-plug ########
"########################
call plug#begin('~/.config/nvim/plugged')

Plug 'alker0/chezmoi.vim'                       " Chezmoi highlighting support
Plug 'vim-airline/vim-airline'                  " Fancy and helpful status bar
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocompletion, linting, coding like VSCode
Plug 'preservim/nerdtree'                       " NerdTree file finder
Plug 'Xuyuanp/nerdtree-git-plugin'              " NerdTree support for modified, error, etc files
Plug 'ryanoasis/vim-devicons'                   " NerdTree Fancy icons for files and directories
Plug 'ctrlpvim/ctrlp.vim'                       " Fuzzy file finder (to search by name)
Plug 'preservim/nerdcommenter'                  " Powerfull commenter
Plug 'airblade/vim-gitgutter'                   " Mark changed lines in a file
Plug 'christoomey/vim-tmux-navigator'           " Change windows with <C-{hjkl}>
Plug 'morhetz/gruvbox'                          " Nice retro color scheme for vim
Plug 'alvan/vim-closetag'                       " Tag closer html like
Plug 'chrisbra/Colorizer'                       " Colorize hex values and colors
Plug 'vimwiki/vimwiki'                          " Vimwiki for note taking
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
                                                " Markdown Viewer
Plug 'ferrine/md-img-paste.vim'                 " Copy image from clipboard in md
Plug 'godlygeek/tabular'                        " Syntax Highlighting for markdown
Plug 'plasticboy/vim-markdown'                  " Including math

call plug#end()

"############ Coc config ############

let g:coc_global_extensions = [
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-sh',
  \ 'coc-tsserver',
  \ 'coc-pairs',
  \ 'coc-eslint',
  \ 'coc-json',
  \ 'coc-snippets',
  \ 'coc-clangd',
  \ 'coc-spell-checker',
  \ 'coc-cspell-dicts',
  \ 'coc-swagger',
  \]

" coc-spell-checker configuration
vmap <C-Space> <Plug>(coc-codeaction-selected)w
nmap <C-Space> <Plug>(coc-codeaction-selected)w

" coc-snippets <TAB> functionality
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
xmap <Tab> <Plug>(coc-snippets-select)

" coc-prettier format with <C-f>
vmap <C-f>  <Plug>(coc-format-selected)
nmap <C-f>  <Plug>(coc-format-selected) 

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved."
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column int:o one"
    set signcolumn=number
else
    set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"  other plugin before putting this into your config.""'>'
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : \<"C-h>"

function! s:check_back_space() abort
      let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
endfunction
    
" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at
" current position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocActionAsync('doHover')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand','editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
let g:airline#extensions#coc#enabled = 0
let airline#extensions#coc#error_symbol = 'Error:'
let airline#extensions#coc#warning_symbol = 'Warning:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


"############ NerdTree config ############
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | q
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | wincmd p | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set encoding=UTF-8

"############ CtrlP config ############
" To update NerdTree when is open
function! IsNERDTreeOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! SyncTree()
    if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
        NERDTreeFind
        wincmd p
    endif
endfunction

autocmd BufEnter * call SyncTree()

"############ NerdCommenter config ############
" Remap <C-k> to comment
nmap <C-_> <plug>NERDCommenterToggle " This works cause <C-/> sends ^_
vmap <C-_> <plug>NERDCommenterToggle " This works cause <C-/> sends ^_

"############### Gruvbox config ###############
"For transparent bg:
autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
            \ |    highlight LineNr     ctermbg=NONE guibg=NONE
            \ |    highlight SignColumn ctermbg=NONE guibg=NONE
colorscheme gruvbox

"############### CloseTags config ###############
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.js"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js,*.erb'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

"############### Vimwiki config #################
let studiousWiki = {}
let studiousWiki.path = '/mnt/c/Users/Cori/Documents/Tareas/studious/'
let studiousWiki.syntax = 'markdown'
let studiousWiki.ext = '.md'

let personalWiki = {}
let personalWiki.path = '/mnt/c/Users/Cori/Documents/Notas/Personales/'
let personalWiki.syntax = 'markdown'
let personalWiki.ext = '.md'

let g:vimwiki_list = [studiousWiki, personalWiki]

" coc-snippets compatibility settings
let g:vimwiki_global_ext = 0
let g:vimwiki_table_mappings = 0

" coc-spell-checker compatibility remap
nmap <Leader><Space> <Plug>VimwikiToggleListItem

"############### Markdown Preview config ########
nmap <C-e> <Plug>MarkdownPreviewToggle
let g:mkdp_preview_options = {
    \ 'mkit': {"breaks": 1},
    \ 'sync_scroll_type': 'middle',
    \ }
let g:mkdp_page_title = '${name}'

"######## Markdown Image Paste config ###########
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
 "there are some defaults for image directory and image name, you can change them
 let g:mdip_imgdir = 'img'
 let g:mdip_imgname = 'image'

"############### Vim Markdown ###################
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1

"############################
"#### non-Plugin config "####
"############################

set bg=dark

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default.
set backspace=indent,eol,start

" When oppening new files, don't close the current one, but hide it.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement.
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Disable expandtab for certain files
autocmd FileType asm setlocal noexpandtab
" Set indenting and tab spaces to 2 for certain files
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" Enable toggle paste mode, (currently paste messes up with coc-pairs and auto
" comment lines)
set pastetoggle=<F2>
