"/"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


function! JoinParagraphs()
  let lnum = 1
  let last = line('$')
  while lnum <= last
    " Skip blank lines
    if getline(lnum) =~ '^\s*$'
      let lnum += 1
      continue
    endif
    " While the next line exists and is not blank, join it
    while lnum < line('$') && getline(lnum+1) !~ '^\s*$'
      execute lnum . 'join'
      let last = line('$') " Buffer shrinks as we join
    endwhile
    let lnum += 1
  endwhile
endfunction

" Find the project root directory by looking for .git or tags file.
function! FindProjectRoot()
  let l:dir = expand('%:p:h')
  while !isdirectory(l:dir . '/.git') && !filereadable(l:dir . '/tags')
    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent == l:dir
      return getcwd()
    endif
    let l:dir = l:parent
  endwhile
  return l:dir
endfunction

" Update the tags file in the project root directory.
" autocmd BufWritePost * silent! execute '!ctags --update -f ' . FindProjectRoot() . '/tags %' | redraw!

""""""""""""""""""""""  vim settings """""""""""""""""""""""""""""""""""""""""""
set nocompatible
set autoread
filetype off
set encoding=utf-8

" Do not automcatilly add a new line in the end of file.
set nofixeol

" Allow backspace to work as expected..
map! <C-h> <BS>
set bs=indent,eol,start

" ctags optimization
" see also https://stackoverflow.com/questions/5542675/how-to-get-ctags-working-inside-vim
set tags=tags;

" Allow mouse movements, resise, file selection in Nerd etc.
set mouse=a

" Allows mouse split resize inside tmux.
"
if !has('nvim')
    if has("mouse_sgr")
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    end
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


" map the <leader> tab to open fzf buffers.
nnoremap <leader><Tab> :Buffers<CR>

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
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'github/copilot.vim'
Plugin 'junegunn/fzf.vim'
call vundle#end()
filetype plugin indent on

" Disable the fzf preview window to make filenames more readable.
let g:fzf_preview_window = []

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
    " colorscheme glacier
    " set t_Co=256
    " colorscheme PaperColor
    " set background=dark
    " colorscheme PaperColor
else
    " Vim is running remotely.
    " Set the color scheme for SSH host.
    " colorscheme zenburn
endif


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

" Start the debugger.
nnoremap <leader>d :Termdebug<CR>

" The following two mappings are useful when we have yanked a text and then
" deleted some other text to use the yanked.

" Use leader p to copy the last yanked text.
nnoremap <leader>p "0p
vnoremap <leader>p "0p

" Use leader q to replace existing word with last yanked text.
nnoremap <leader>q  viw"0p


" Replace visually selected text with yanked text(in reg 0).
vnoremap p "0p

" Enable folding
set foldmethod=indent
set number

" Run autopep when F2 is pressed.
" nnoremap <F2> :!autopep8 --in-place --aggressive --aggressive %<CR><CR>
" nnoremap <F2> :!black %<CR><CR>

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

" Fixing slow Esc key
" https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode

if !has('nvim')
    set noesckeys
endif
set ttimeoutlen=50

" Disable the bell.
set belloff=all

let g:NERDTreeShowLineNumbers=1
set t_Co=256
" set background=dark
set background=light
colorscheme PaperColor
" highlight Normal ctermbg=white
set nocursorline

let g:python_interpreter = "python3"

set tags=./tags,tags;


command! -nargs=1 Ggrep cexpr system('git grep -n <args>') | copen

" Enable autochdir if desired.
set autochdir

let g:initial_cwd = getcwd()

" Ctrl P runs fzf.
" nnoremap <C-p> :<C-u>FZF<CR>
" Set the original working directory as the initial directory for fzf.
" This means that when you press Ctrl-P it will start searching from the
" directory where you first opened Vim.
nnoremap <C-p> :<C-u>execute 'FZF ' . g:initial_cwd<CR>


" Function to format a Python file with isort and black
function! FormatPython()
    let l:filename = expand('%:p')
    " Run isort and black silently and suppress all output
    silent! execute ':!isort ' . shellescape(l:filename) . ' > /dev/null 2>&1'
    silent! execute ':!black ' . shellescape(l:filename) . ' > /dev/null 2>&1'
    " Reload the file
    edit!
endfunction

" Create an autocommand group to avoid duplicate autocommands
augroup format_on_save
    autocmd!
    " When saving a Python file, run the formatter
    autocmd BufWritePost *.py call FormatPython()
augroup END


nnoremap <leader>l :call ToggleBackground()<CR>

function! ToggleBackground()
    if &background ==# 'dark'
        set background=light
    else
        set background=dark
    endif
endfunction

" Enable termdebug plugin for debugging.
packadd! termdebug


