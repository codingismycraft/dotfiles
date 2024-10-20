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
set autoread
filetype off
" Used gnome-tweaks to map Caps to Esc.
" Follow this: Additional Layout Options -> Caps Lock behavior 

" Allow backspace to work as expected..
map! <C-h> <BS>
set bs=indent,eol,start

" ctags optimization
" see also https://stackoverflow.com/questions/5542675/how-to-get-ctags-working-inside-vim
set tags=tags;

" Allow mouse movements, resise, file selection in Nerd etc.
set mouse=a

" Allows mouse split resize inside tmux.
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

colorscheme glacier

" set clipboard=unnamed
set clipboard^=unnamed,unnamedplus

" You can uncomment the following line to get windows bindings.
" source $VIMRUNTIME/mswin.vim
" source $HOME/.vim/mswin.vim


" Working directory is always the same as the file you are editing.
" set autochdir

" Allow to change buffer even if current buffer has unsaved changes.
set hidden

set number

" Ignore case in searches.
set ignorecase

set shiftwidth=4

" Mimic the arrow keys when in command mode.
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-l> <Right>
cnoremap <C-h> <Left>

" Maps CTRL-j and CTRL-k to move by 20 lines.
" Yes, could be controversial to a vim purist but makes my life easier!
noremap <C-j> 20j
noremap <C-k> 20k
noremap <C-h> 20h
noremap <C-l> 20l

" Open the active document in the browser.
" Using firefox and assumes that the Markdown Viewer Webext extension.
map <F8> :!firefox %:p<CR><CR>

" Open the active document as pdf.
nnoremap <F9> :!pandoc -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -V toccolor=gray % -o junk.pdf -f markdown+implicit_figures  && evince junk.pdf<CR><CR>


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
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Hide the menu and the scroll bars. (gvim only)
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

" Sets the default text width.
set tw=79

set nowrap
set laststatus=2 " Show status line always.
set nobackup
set noswapfile
set nofoldenable


let python_highlight_all=1
syntax on
set t_Co=256
set cursorline


" Enable fsz for quick file discovery.
" https://www.linode.com/docs/guides/how-to-use-fzf/
set rtp+=~/.fzf 

" Open fzf on the bottom on the screen.
let g:fzf_layout = { 'down': '30%' } 

" Disable status line for fzf window.
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


" Install plugins.
set rtp+=~/.vim/bundle/Vundle.vim


call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'codingismycraft/pdbnavigate'
Plugin 'codingismycraft/VimCommentator'
Plugin 'codingismycraft/VimStatusLine'
Plugin 'tpope/vim-fugitive'
Plugin 'preservim/vimux'
Plugin 'codingismycraft/vimdemux'
Plugin 'dense-analysis/ale'
call vundle#end()            
filetype plugin indent on    

nnoremap <C-p> :<C-u>FZF<CR> 

" For python code map Ctrl + ] to go to definition using youcompleteme.
autocmd FileType python nnoremap <C-]> <Esc>:YcmCompleter GoToDefinition<CR>

" YouCompleteMe
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_python_binary_path='/usr/bin/python3'

" Disable the preview window.
set completeopt-=preview

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


function! SaveCliboard()
    let @z=@+
endfunction

function! PasteZBuffer()
    norm viwy
    if len(@") > 1
        norm diwh"zp
    else
        norm x 
        norm "zp
    endif
endfunction

" leader+z copies the value from the system clipboard to register z.
nnoremap <leader>z :call SaveCliboard()<CR><esc>

" Replace word under cursor with yanked text(in reg 0).
nnoremap <leader>p :call PasteZBuffer()<CR><esc>

nnoremap <F2> :!autopep8 --in-place --aggressive --aggressive %<CR><CR>

" Map the ss to save when in normal mode. 
nnoremap <leader>s   <ESC>:write<CR>

ab __m if __name__ == '__main__':


" leader prefixed keybindings.
let mapleader=" "

" Save all changes.
nnoremap<leader>s <Esc>:wall<CR>

" Change the relative number.
noremap <leader>a :set rnu!<CR>

" Run the current python program. 
noremap <leader>r :!python3 %<CR>

" Cut - Paste the contents of the 0 register.
nnoremap <leader>c diw"0P<esc>

" Count words.
nnoremap <leader>q :echo "Total number of words:" wordcount().words<CR>

" Quit / Delete the buffer (removing it from the memory).
nnoremap <leader>q :bd<CR>

" Change active window.
nnoremap <leader>w <C-w><C-w><cr>

" List the current directory 
nnoremap <leader>f :Ex<CR>

nnoremap <tab> :bn<CR>
nnoremap <C-tab> :bp<CR>  

nnoremap<C-'> <Esc>:tabn<CR>
nnoremap<C-;> <Esc>:tabp<CR>

" Replace visually selected text with yanked text(in reg 0).
vnoremap p "0p

" Enable folding
set foldmethod=indent

function! GetAlertLogs()
    let x = @+
    :new
    execute ": r !get_alert_logs.py " . x
endfunction

nnoremap <leader>m :call GetAlertLogs()<CR>


function! GetGitUrls()
    let fullpath = expand("%:p")
    execute ":new "
    execute ":silent r !remote_git_urls.py " . fullpath
    execute ":setlocal nomodifiable"
    execute ":call setbufvar(bufnr('%'), '&modified', 0)"
endfunction

function! MakeDocStr()
    let fullpath = expand("%:p")
    execute ":new "
    execute ":silent r !make_docstr.py " . fullpath
    execute ":call setbufvar(bufnr('%'), '&modified', 0)"
endfunction

function! MakeUnitTest()
    let fullpath = expand("%:p")
    execute ":new "
    execute ":silent r !make_unit_test.py " . fullpath
    execute ":call setbufvar(bufnr('%'), '&modified', 0)"
endfunction

function! PrintMenu()
  echo "Menu:"
  echo "1. Option 1 - press \\1"
  echo "2. Option 2 - press \\2"
endfunction

function! RemoveTrailingSpaces()
    execute(":%s/\s\+$//e")
endfunction


" Shift + End : Select to the end of the line
nmap <S-End> v$

" Ctrl + Shift + Right Arrow: Select world
nmap <C-S-Right> viw


" In the following two mappings note the use of execute which is
" needed since the double quote symbol used for register 0 will be
" considered the begining of a comment and be ignored without it.

" Map Ctrl + Insert to paste the 0 register (avoiding last delete)
execute 'nmap <C-Ins> "0p'

" Map Shift + p to paste the 0 register (avoiding last delete)
execute 'nmap <S-p> "0p'
