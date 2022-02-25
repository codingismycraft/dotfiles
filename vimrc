 " Customized version of vimrc.

set nocompatible

" Allow backspace to work as expected..
map! <C-h> <BS>
set bs=indent,eol,start

filetype plugin on

colorscheme onehalfdark

set clipboard=unnamed

" Set the Space key as the leader
nnoremap <SPACE> <Nop>
let mapleader=" "

" You can uncomment the following line to get windows bindings.
" source $VIMRUNTIME/mswin.vim

" Working directory is always the same as the file you are editing.
set autochdir

" Map the escape key in insert mode.
inoremap jj <Esc>

" Map the ss to save when in normal mode. 
nnoremap <leader>s <Esc>:write<CR>

" Allow to change buffer even if current buffer has unsaved changes.
set hidden

set t_kb=^H
fixdel

" Allows the backspace to behave <normally>.
imap<Del> <C-H>

" Save file using <Ctrl S>
map <C-s> <ESC>:write<CR>
imap <C-s> <ESC>:write<CR>

" Maps Ctrl+a to select the whole file.
" map <C-a> GVgg

" Maps Ctrl+z to undo.
map <C-z> u
inoremap <C-z> <esc>u

set number

" Ignore case in searches.
set ignorecase

" Toggle relative line number.
noremap <leader>a :set rnu!<CR>

set shiftwidth=4
vmap <TAB> >
vmap <S-TAB> <

map <F9> <ESC>:write<CR>

" Map Control Tab and Control Shift Tab to buffer next and
" previous to mimic the way Visual Studio or pycharm is
" changing windows.
map <C-TAB> :bn<CR>
map <C-S-TAB> :bp<CR>

" Mimic the arrow keys when in command mode.
cmap <C-k> <Up>
cmap <C-j> <Down>
cmap <C-l> <Right>
cmap <C-h> <Left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      Copy - Paste shortcuts 
"
" Yes, I do not care about multiple registers when it comes
" to copy/ paste; instead I prefer to use only one clipboard
" to simplify the related processes and allow a simpler and
" cleaner behavior.

" Allow to select using arrows + home + end.
" behave mswin
" 
" noremap y "+y
" noremap yy "+yy
" noremap dd "+dd
" noremap d "+d
" noremap p "+p
" 
" Replace word with yanked text when in normal mode.
map <leader>c ciw<C-r>0<esc>

" Open the active document in the browser.
map <F8> :!google-chrome %:p<CR><CR>

" F2 sources the vimcrc,
map <F2> :source $MYVIMRC<CR>

" F3 To load all to Todo items.
map <F3> : call FindMatches("TODO")<CR>

" Maps leader - d to replace the underlined word to DONE.
map <leader>d cawDONE <esc>

" Maps leader - t to replace the underlined word to TODO .
map <leader>t cawTODO <esc>

" The name of the buffer where search results are printed.
let g:SEARCH_BUFF_NAME = "_search_buffer"
    
function! FindMatches(text_to_find)
    " Finds all the matches for the passed in text.
    " 
    " Checks recursively the directories in path and stores
    " the matches in a buffer called _search_buffer.
    "
    " There are three different cases:
    "
    " 1. The buffer does not exist.
    "    
    "    In this case there is also no related window.
    "
    " 2. The buffer exists.
    "
    "    2.1 There is no window for the buffer
    "
    "    2.2 There is an open window for the buffer.
    if buflisted(g:SEARCH_BUFF_NAME)
        " The buffer exists. Let's see if it is visible in a window.
        let window_index =  bufwinnr(g:SEARCH_BUFF_NAME)
        if window_index > 0
            " The buffer is open in a window, let's activate it.
            execute window_index 'wincmd w'
        else
            " No window is open for the buffer.
            new
            execute "buffer ". g:SEARCH_BUFF_NAME 
        endif
    else
        " The buffer does not exist, go ahead and create it!
        new
        execute "file ". g:SEARCH_BUFF_NAME
        setlocal buftype=nofile
        setlocal bufhidden=hide
    endif
    " Clear the screen.
    normal! ggdG
    " Add a header.
    call append(0, "Search results for ". a:text_to_find)
    " Run the search.
    execute 'read !grep -r ' . a:text_to_find . " ~/myprojects"
    " Update the customized color highlights.
    call UpdateHighlights()

endfunction


function! ClearRegisters()
    " Clears all registers.
    "
    " See also: https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
endfunction

" While in insert mode it is awkward to move the cursor
" and the most common way is to get in normal mode and
" use the movement keys and then press i again to rerurn
" to input mode. 
"
" An alternative way to move the cursor while in insert 
" mode would be to use the arrow keys but this would move
" our fingers from the home row. 

" To address this issue I am adding the followin shortcut
" moves when in insert mode using <Ctrl> hjkl.
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" Hide the menu and the scroll bars.
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L  "remove left-hand scroll bar

" Sets the autoindent so when pressing enter the cursor is indended.
set autoindent

" map bb :!gcc -g expand('%:p') -o expand('%:p:h')/a.out <CR>

set tabstop=4
set guioptions-=T

" Verifies that trailing spaces not show up as $ (Toggle to make visible).
set nolist

set expandtab
au BufReadPost * retab


set tw=79

set nowrap
set laststatus=2
set nobackup
set noswapfile
set nofoldenable
set laststatus=2

function! AddToDo()
    r ~/.vim/mytemplates/todo-template
endfunction

function! AddRockportQA()
    r ~/.vim/mytemplates/rockport-qa-template
endfunction

syntax on
set t_Co=256
set cursorline

" Update the custom highlights.
function! UpdateHighlights()
        hi DONE_COLOR ctermbg=205 guibg=green guifg=black ctermfg=black
        call matchadd('DONE_COLOR', 'DONE')

        " Highlight the TODO and DONE words (usefull in TODO lists)..
        hi TODO_COLOR ctermbg=205 guibg=hotpink guifg=black ctermfg=black
        call matchadd('TODO_COLOR', 'TODO')

        hi HEADER_COLOR ctermbg=205 guifg=cyan ctermfg=black
        call matchadd('HEADER_COLOR', '^`.*$')

        hi HOW_TO_COLOR ctermbg=205 guifg=green ctermfg=black
        call matchadd('HOW_TO_COLOR', '^HOWTO.*$')

endfunction

call UpdateHighlights()

set path+=~/myprojects/**

let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V·LINE',
    \ '' : 'V·BLOCK',
    \ 's'  : 'SELECT',
    \ 'S'  : 'S·LINE',
    \ '' : 'S·BLOCK',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·REPLACE',
    \ 'c'  : 'COMMAND',
    \}


" Set Status line.
set statusline=%{g:currentmode[mode()]}%#StatusLine#\ %n\ %F\ %l:%c
"set statusline+=%{g:currentmode[mode()]}
hi StatusLine cterm=bold ctermbg=21 guibg=blue guifg=cyan

" Enable fsz for quick file discovery.
set rtp+=~/.fzf 
nnoremap <C-p> :<C-u>FZF<CR> 

function! Com_out()
    execute 'normal! ^\<C-v>10j\<S-i>#<esc>'
    echo "here ...."
endfunction

