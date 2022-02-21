" Customized version of vimrc.

set nocompatible

" Allow backspace to work as expected..
map! <C-h> <BS>
set bs=indent,eol,start

filetype plugin on

colorscheme onehalfdark

" Bind cliboard to unnamed register.
set clipboard=unnamed

" Set the Space key as the leader
nnoremap <SPACE> <Nop>
let mapleader=" "

" You can uncomment the following line to get windows bindings.
" source $VIMRUNTIME/mswin.vim

" Working directory is always the same as the file you are editing.
set autochdir

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
map <C-a> GVgg

" Maps Ctrl+z to undo.
map <C-z> u
inoremap <C-z> <esc>u

set number

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

set shiftwidth=4
vmap <TAB> >
vmap <S-TAB> <

map <F9> <ESC>:write<CR>

" Map Control Tab and Control Shift Tab to buffer next and
" previous to mimic the way Visual Studio or pycharm is
" changing windows.
map <C-TAB> :bn<CR>
map <C-S-TAB> :bp<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      Copy - Paste shortcuts 
"
" Yes, I do not care about multiple registers when it comes
" to copy/ paste; instead I prefer to use only one clipboard
" to simplify the related processes and allow a simpler and
" cleaner behavior.

" Allow to select using arrows + home + end.
behave mswin 

map <F8> :!google-chrome %:p<CR><CR>
map <F2> :source $MYVIMRC<CR>
map <F3> :r !grep -r TODO ~/myprojects<CR>
map <F4> :r !grep -r DONE ~/myprojects<CR>

" Maps leader - d to replace the underlined word to DONE.
map <leader>d cawDONE <esc>

" Maps leader - t to replace the underlined word to TODO .
map <leader>t cawTODO <esc>

" The name of the buffer where search results are printed.
let g:SEARCH_BUFF_NAME = "_search_buffer"
    
function! F(text_to_find)
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


" Maps CTRL-j and CTRL-k to move by 10 lines.
map <C-j> 10j
map <C-k> 10k
map <C-h> 10h
map <C-l> 10l

" Hide the menu and the scroll bars.
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L  "remove left-hand scroll bar

" Sets the line numbering to be current line related.
" set relativenumber

" Sets the autoindent so when pressing enter the cursor is indended.
set autoindent

" map bb :!gcc -g expand('%:p') -o expand('%:p:h')/a.out <CR>

set tabstop=4
set guioptions-=T
set list
set expandtab
au BufReadPost * retab
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


" hi DONE_COLOR ctermbg=205 guibg=green guifg=black ctermfg=black
" call matchadd('DONE_COLOR', 'DONE')

" Highlight the TODO and DONE words (usefull in TODO lists)..
" hi TODO_COLOR ctermbg=205 guibg=hotpink guifg=black ctermfg=black
" call matchadd('TODO_COLOR', 'TODO')

" syn match   cCustomMember "CODING.*$"
" hi def link cCustomMember Number

" Highlight the task header.
" hi HEADER_COLOR ctermbg=205 guibg=blue guifg=cyan ctermfg=black
"
" hi HEADER_COLOR ctermbg=205 guifg=cyan ctermfg=black
" call matchadd('HEADER_COLOR', '^`.*$')

" hi HOW_TO_COLOR ctermbg=205 guifg=green ctermfg=black
" call matchadd('HOW_TO_COLOR', '^HOWTO.*$')

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
hi StatusLine cterm=bold ctermbg=21 guibg=LightYellow

"Enable fsz.
set rtp+=~/.fzf 
nnoremap <C-p> :<C-u>FZF<CR> 

" See also https://superuser.com/questions/61226/configure-vim-for-copy-and-paste-keyboard-shortcuts-from-system-buffer-in-ubuntu
"" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>       "+gP
map <S-Insert>      "+gP

cmap <C-V>      <C-R>+
cmap <S-Insert>     <C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>     <C-V>
vmap <S-Insert>     <C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>       <C-V>

" Vim support file to help with paste mappings and menus
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last Change:  2006 Jun 23

" Define the string to use for items that are present both in Edit, Popup and
" Toolbar menu.  Also used in mswin.vim and macmap.vim.

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.  Add to that some tricks to leave the cursor in
" the right position, also for "gi".
if has("virtualedit")
  let paste#paste_cmd = {'n': ":call paste#Paste()<CR>"}
  let paste#paste_cmd['v'] = '"-c<Esc>' . paste#paste_cmd['n']
  let paste#paste_cmd['i'] = 'x<BS><Esc>' . paste#paste_cmd['n'] . 'gi'

  func! paste#Paste()
    let ove = &ve
    set ve=all
    normal! `^
    if @+ != ''
      normal! "+gP
    endif
    let c = col(".")
    normal! i
    if col(".") < c " compensate for i<ESC> moving the cursor left
      normal! l
    endif
    let &ve = ove
  endfunc
else
  let paste#paste_cmd = {'n': "\"=@+.'xy'<CR>gPFx\"_2x"}
  let paste#paste_cmd['v'] = '"-c<Esc>gix<Esc>' . paste#paste_cmd['n'] . '"_x'
  let paste#paste_cmd['i'] = 'x<Esc>' . paste#paste_cmd['n'] . '"_s'
endi
