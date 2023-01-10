call pathogen#infect()
syntax on
filetype plugin indent on

set backupdir=~/tmp
set directory=~/tmp
set nocompatible
set history=1000
set showcmd    "show incomplete cmds down the bottom
set showmode   "show current mode down the bottom
set incsearch  "find the next match as we type the search
set hlsearch   "hilight searches by default
set number     "add line numbers
set showbreak=...
set wrap linebreak nolist
set linespace=4
set visualbell t_vb=
set shiftwidth=2
set softtabstop=2
set expandtab
set nobackup
set nowritebackup
set noswapfile

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2
set hidden
set nowrap
set nu
set ts=2 sts=2 sw=2 expandtab
set colorcolumn=120
syntax enable
colorscheme BusyBee
highlight ColorColumn ctermbg=0 guibg=lightgrey

ab rdb require 'ruby-debug';debugger
ab pry require 'pry'; binding.pry

let mapleader = ","
augroup filetypedetect
  autocmd BufRead,BufNewFile *.prawn set filetype=ruby
augroup END

" Agradeça ao Gabriel depois
nnoremap ; :

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"statusline setup
set statusline=%f       "tail of the filename
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"make Y consistent with C and D
nnoremap Y y$

"key mapping for tab navigation
nmap <Tab> gt
nmap <S-Tab> gT

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
  let targetWidth = a:width != '' ? a:width : 79
  if targetWidth > 0
    exec 'match Todo /\%>' . (targetWidth) . 'v/'
  else

endfunction

" == KEYBINDINGS ===================================================
"key mapping for vimgrep result navigation

map <leader>rf :Dispatch bin/rspec %<CR>
map <leader>ra :Dispatch bin/rspec spec<CR>
map <leader>bi :Dispatch bundle install --binstubs<CR>

" Tab mappings.
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tablast<cr>
map <leader>tm :tabmove

nnoremap <C-j> 5j
nnoremap <C-k> 5k

nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

nnoremap <leader>c :bd<CR>
nnoremap <leader>ft Vatzf
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:let @/=''<CR>
nnoremap <leader>q gqip
nnoremap <leader>v V`]
nnoremap <leader>l :nohlsearch<CR>
inoremap jj <ESC>

imap <C-l> <Space>=><Space>

" Edit my .vimrc on new tab
nmap <leader>v :tabedit $MYVIMRC<CR>

" Reload the vimrc file after saving it
if has("autocmd")
  " save on lost focus
  au FocusLost * :wa
  
  autocmd bufwritepost .vimrc source $MYVIMRC
  
  " Treat different file types as one we know. Example:
  " autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
  
  " Automatically remove whitespaces while saving files
  autocmd BufWritePre *.snippet,*.yml,*.rb,*.html,*.css,*.erb,*.haml :call <SID>StripTrailingWhitespaces()
  autocmd BufRead,BufNewFile *.scss set filetype=scss
endif

" As seen on Vimcasts
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business
  %s/\s\+$//e
  " Clean up: restore previous search history and cursor position
  let @/=_s
  call cursor(l,c)
endfunction

autocmd BufRead,BufNewFile *.tokamak set filetype=ruby

set runtimepath^=~/.vim/bundle/ctrlp.vim

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|target|_build|deps$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ }
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : ['#(whoami)', '#(uptime | cud -d " " -f 1,2,3)'],
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '#(~/bin/battery)',
      \'y'    : '%R %a %Y',
      \'z'    : '#H'}

" Elixir format
let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'
let g:mix_format_silent_errors = 1

" Neovim autocomplete
set pyxversion=3
set encoding=utf-8
let g:deoplete#enable_at_startup = 0
let g:alchemist#elixir_erlang_src = "/usr/local/share/src"

" Configuration for vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Better display for messages
set cmdheight=2

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Remap for do action format
nnoremap <silent> F :call CocAction('format')<CR>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Git blame
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>
