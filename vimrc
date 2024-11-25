""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""" Global Functions """"""""""""""""""""""""""""""""""""""

" Clears the contents of all Vim registers.
function! ClearRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
endfunction

"Open the current file's GitHub repo in Firefox.
function! OpenInGitHub()
    " Opens the current file in github if it is under version control.
    let l:current_file = expand('%:p')
    let l:command = 'remote_git_urls.py ' . shellescape(l:current_file)
    " Execute the command and capture its output
    let l:output = system(l:command)
    " If there were any execution issues, handle them
    if v:shell_error
        echoerr "Error running command: " . l:command
        return
    endif
    execute ":!firefox ". trim(l:output)
endfunction

function! Scratch()
let name="scratch-pad"
let windowNr = bufwinnr(name)
if windowNr > 0
    execute windowNr 'wincmd w'
else
    execute "sp ". name
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endif
endfunction

""""""""""""""""""""""  vim settings """""""""""""""""""""""""""""""""""""""""""
set nocompatible
set autoread
filetype off

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

" set clipboard=unnamed
set clipboard^=unnamed,unnamedplus

" Uncomment the following for Working directory to always be the same as the
" file you are editing.
" set autochdir

" Allow to change buffer even if current buffer has unsaved changes.
set hidden

set relativenumber

" Ignore case in searches.
set ignorecase

set shiftwidth=4

" Mimic the arrow keys when in command mode.
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-l> <Right>
cnoremap <C-h> <Left>

" Maps CTRL-j and CTRL-k to move by 20 lines.
noremap <C-j> 20j
noremap <C-k> 20k
noremap <C-h> 20h
noremap <C-l> 20l


"Use `<Ctrl>` + `hjkl` in insert mode for arrow key movement, staying on home row."
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

" =======================  fzf settings ===============================
set rtp+=~/.fzf

" Open fzf on the bottom on the screen.
let g:fzf_layout = { 'down': '30%' }

" Disable status line for fzf window.
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Ctrl P runs fzf.
nnoremap <C-p> :<C-u>FZF<CR>

" ==================  Set behavior for local / remote host  =================
if $SSH_CONNECTION == ""
    " Vim is running locally thus it has access to X11.

    " Open the active document in the browser.
    " Using firefox and assumes that the Markdown Viewer Webext extension.
    nnoremap <F8> :!firefox %:p<CR><CR>

    " Open the active document as pdf.
    nnoremap <F9> :!pandoc -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -V toccolor=gray % -o junk.pdf -f markdown+implicit_figures  && evince junk.pdf<CR><CR>

    " If exists open the file under github.
    nnoremap <F7> :call OpenInGitHub()<CR><CR>

    " Set the color scheme for local host.
    colorscheme glacier
else
    " Vim is running remotely.
    " Set the color scheme for SSH host.
    colorscheme zenburn
endif

" =============================  Plugins  =============================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'codingismycraft/VimCommentator'
Plugin 'codingismycraft/VimStatusLine'
Plugin 'codingismycraft/VimMyTools'
Plugin 'tpope/vim-fugitive'
Plugin 'dense-analysis/ale'
call vundle#end()
filetype plugin indent on

" =======================  YouCompleteMe Settings  ================================
"
" For python code map Ctrl + ] to go to definition using youcompleteme.
autocmd FileType python nnoremap <C-]> <Esc>:YcmCompleter GoToDefinition<CR>
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_python_binary_path='/usr/bin/python3'
"=================================================================================

" Disable the preview window.
set completeopt-=preview

" leader prefixed keybindings.
let mapleader=" "

" Save all changes.
nnoremap<leader>s <Esc>:wall<CR>
map<C-s> <Esc>:wall<CR>

" Change the relative number.
noremap <leader>a :set rnu!<CR>

" Change active window.
nnoremap <leader>w <C-w><C-w><cr>

" List the current directory
nnoremap <leader>f :Ex<CR>

" The following two mappings are useful when we have yanked a text and then
" deleted some other text to use the yanked.

" Use leader p to copy the last yanked text.
nnoremap <leader>p "0p
vnoremap <leader>p "0p

" Use leader q to replace existing word with last yanked text.
nnoremap <leader>q  viw"0p
nnoremap <silent><leader>n :call Scratch()<cr>


" Replace visually selected text with yanked text(in reg 0).
vnoremap p "0p

" Enable folding
set foldmethod=indent
set number

" Run autopep when F2 is pressed.
nnoremap <F2> :!autopep8 --in-place --aggressive --aggressive %<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""
" When set to 0 the cursor won't jump automatically
" see here https://stackoverflow.com/questions/35390415/cursor-jump-in-vim-after-save
" When the autocmd is executed to remove trailing spaces before saving
" use the following to keep the cursor from jumping to the last change
" and loose the current location..
"
" Remove training spaces before save.
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd! BufWritePre * :call <SID>StripTrailingWhitespaces()

let g:syntastic_auto_jump = 0
"""""""""""""""""""""""""""""""""""""""""""""""""

ab __main if __name__ == '__main__':

