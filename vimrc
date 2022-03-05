"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"                               John Pazarzis
"
"        My customized version of vimrc; a moving target as I keep on
"        changing it often to meet my needs.  Trying to keep things
"        as simple as possible, avoid the use of plugins as much as
"        possible and rely mostly on standard settings without having
"        to result to many gimmicks.
"
"        This vimrc is using python's vim module to extrend Vimscript
"        so you should be sure that the vim's version used is compiled
"        with the python option on (you should see the +python from 
"
"        ,---,---,---,---,---,---,---,---,---,---,---,---,---,-------,
"        |1/2| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | + | ' | <-    |
"        |---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-----|
"        | ->| | Q | W | E | R | T | Y | U | I | O | P | ] | ^ |     |
"        |-----',--',--',--',--',--',--',--',--',--',--',--',--'|    |
"        | Caps | A | S | D | F | G | H | J | K | L | \ | [ | * |    |
"        |----,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'---'----|
"        |    | < | Z | X | C | V | B | N | M | , | . | - |          |
"        |----'-,-',--'--,'---'---'---'---'---'---'-,-'---',--,------|
"        | ctrl |  | alt |                          |altgr |  | ctrl |
"        '------'  '-----'--------------------------'------'  '------'
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible

" Used gnome-tweaks to map Caps to Esc.
" Follow this: Additional Layout Options -> Caps Lock behavior 

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

" set t_kb=^H
" fixdel
" 
" " Allows the backspace to behave <normally>.
" imap<Del> <C-H>
" 
" Save file using <Ctrl S>
map <C-s> <ESC>:write<CR>
imap <C-s> <ESC>:write<CR>

" Maps Ctrl+z to undo.
map <C-z> u
inoremap <C-z> <esc>u

set number

" Ignore case in searches.
set ignorecase

" Toggle relative line number.
noremap <leader>a :set rnu!<CR>

set shiftwidth=4

" Use tab / shift tab when in visual mode to indent code.
vmap <TAB> >
vmap <S-TAB> <

" F9 will save the doc.
map <F9> <ESC>:write<CR>

" Map Control Tab and Control Shift Tab to buffer next and
" previous to mimic the way Visual Studio or pycharm is
" changing windows.
map <C-TAB> :bn<CR>
map <C-S-TAB> :bp<CR>

" The above olution only works for gVim, in console use 
" the tab, shift tab to change buffers.
map <tab> :bn<CR>
map <S-tab> :bp<CR>  

" Mimic the arrow keys when in command mode.
cmap <C-k> <Up>
cmap <C-j> <Down>
cmap <C-l> <Right>
cmap <C-h> <Left>

" Maps CTRL-j and CTRL-k to move by 20 lines.
" Yes, could be controversial to a vim purist but makes my life easier!
noremap <C-j> 20j
noremap <C-k> 20k
noremap <C-h> 20h
noremap <C-l> 20l

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

" Maps leader - w to count words.
map <leader>w :echo "Total number of words:" wordcount().words<CR>

" Maps the leader - n to cancel search highlight,
map <leader>n :execute "noh"<cr>

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

command! -nargs=1 Match :call FindMatches(<args>)


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
set guioptions-=T

" Sets the autoindent so when pressing enter the cursor is indended.
set autoindent

set tabstop=4

" Verifies that trailing spaces not show up as $ (Toggle to make visible).
set nolist

" Expands tabs to spaces when opening a file.
set expandtab
au BufReadPost * retab

" Sets the default text width.
set tw=79

set nowrap
set laststatus=2 " Show status line always.
set nobackup
set noswapfile
set nofoldenable

function! AddToDo()
    r ~/.vim/mytemplates/todo-template
endfunction

function! AddRockportQA()
    r ~/.vim/mytemplates/rockport-qa-template
endfunction

syntax on
set t_Co=256
set cursorline
set tags+=$HOME/repos/pinta/tags

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

" Sets the search path to use with find.
set path+=~/myprojects/**

" Map to mode name.
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

" Pretty simple status line, purposely I am dodging the use of fancy plugins.
set statusline=
set statusline+=%-20t  " File name (tail) of file in the buffer.
set statusline+=%-3n   " The buffer number.
set statusline+=%3*%-3m%* " [+] if the buffer has unsaved changes.
set statusline+=%-10{g:currentmode[mode()]} " The current mode.
set statusline+=\ %5l:%-4c%8L%4p%% " Row - column, total rows, location as %.

" Highlights a changed file in the status line.
hi User3 ctermfg=007 ctermbg=236 guibg=red guifg=black

" The color scheme to use for the active buffer.
hi StatusLine cterm=bold ctermbg=21 guibg=blue guifg=cyan

" The color scheme to use for all the active buffers.
hi StatusLineNC cterm=bold ctermbg=21 guibg=black guifg=Gray

" Enable fsz for quick file discovery.
set rtp+=~/.fzf 
nnoremap <C-p> :<C-u>FZF<CR> 


python3 << endpython


def LinesToTable(lines):
    """Converts the passed in array of lines to a table.

    :param list[str] lines: The list of lines to convert to a table.

    yields: The lines of the generated table.
    """
    import re

    pipe = "|"
    dash = "-"
    space = " "
    comma = ","

    lines = [
        l.replace(pipe, comma)
        for l in lines if re.search(r"[^|^-]", l)
    ]

    wl = []
    words = []
    for line_index, line in enumerate(lines):
        if not line:
            continue
        if line and line[0] == comma:
            line = line[1:]
        if line and line[-1] == comma:
            line = line[:-1]
        words.append([])
        for i, word in enumerate(line.split(",")):
            word = word.strip()
            if i >= len(wl):
                wl.append(0)
            wl[i] = max(wl[i], len(word) + 1)
            words[line_index].append(word)
    for line_index, w in enumerate(words):
        line = pipe
        underline = pipe
        for i in range(len(wl)):
            underline += dash * (wl[i] + 1) + pipe
            if i >= len(w):
                line += space * (wl[i] + 1) + pipe
            else:
                line += space + w[i] + space * (wl[i] - len(w[i])) + pipe
        yield line
        if line_index == 0:
            yield underline


endpython

function! Tablerize()
python3 << endpython
import vim
start = int(vim.eval("""line("'<")""")) -1 
end = int(vim.eval("""line("'>")"""))
selection = vim.current.buffer
lines = selection[start: end]
new_lines = list(LinesToTable(lines))
selection[start:end] = new_lines
endpython
endfunction

" Use TT from the command line to create a table 
" based on the visual selection.
command! TT call Tablerize()

