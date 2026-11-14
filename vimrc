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


" Uncomment the following for Working directory to always be the same as the
" file you are editing.
" set autochdir

" Allow to change buffer even if current buffer has unsaved changes.
set hidden

set relativenumber

"  Make searches case insensitive.
set noignorecase

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



" Hide the menu and the scroll bars. (gvim only)
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L  "remove left-hand scroll bar

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
autocmd BufLeave * if &filetype ==# 'fzf' | set laststatus=2 showmode ruler | endif



" =============================  Plugins  =============================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'codingismycraft/VimCommentator'
Plugin 'codingismycraft/VimStatusLine'
Plugin 'tpope/vim-fugitive'
Plugin 'NLKNguyen/papercolor-theme'
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

endif


" Disable the preview window.
set completeopt-=preview

" leader prefixed keybindings.
let mapleader=" "

" Change the relative number.
noremap <leader>a :set rnu!<CR>

" Start the debugger.
nnoremap <leader>d :Termdebug<CR>

nnoremap <F1> :bn<CR>
nnoremap <F2> :bp<CR>

" Open / Close Nerd tree
nnoremap <F3> :NERDTreeToggle<CR>


" The following two mappings are useful when we have yanked a text and then
" deleted some other text to use the yanked.

" Use leader p to copy the last yanked text.
nnoremap <leader>p "0p
vnoremap <leader>p "0p


" Use leader q to replace existing word with last yanked text.
nnoremap <leader>q  viw"0p

" map the <leader> tab to open fzf buffers.
nnoremap <leader><Tab> :Buffers<CR>


" Replace visually selected text with yanked text(in reg 0).
vnoremap p "0p

" Enable folding
set foldmethod=indent
set number


""""""""""""""""""""""""""""""""""""""""""""""""""""
" When set to 0 the cursor won't jump automatically
" see here:
" https://stackoverflow.com/questions/35390415/cursor-jump-in-vim-after-save
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


inoreab __main if __name__ == '__main__':

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
set background=light

colorscheme PaperColor
set nocursorline

let g:python_interpreter = "python3"

let g:initial_cwd = getcwd()

" Ctrl P runs fzf.
" nnoremap <C-p> :<C-u>FZF<CR>
" Set the original working directory as the initial directory for fzf.
" This means that when you press Ctrl-P it will start searching from the
" directory where you first opened Vim.
nnoremap <C-p> :<C-u>execute 'FZF ' . g:initial_cwd<CR>


nnoremap <leader>l :call ToggleBackground()<CR>

" Favorite color schemes:
let g:my_colorschemes = [
            \ "PaperColor",
            \ "blue",
            \ "darkblue",
            \ "default",
            \ "desert",
            \ "elflord",
            \ "evening",
            \ "habamax",
            \ "industry",
            \ "koehler",
            \ "morning",
            \ "murphy",
            \ "pablo",
            \ "peachpuff",
            \ "retrobox",
            \ "slate",
            \ "sorbet",
            \ "torte",
            \ "wildcharm",
            \ "zenburn"
           \]


let g:colors_idx = 0

function! ToggleBackground()
    " Move to the next index, wrap around to 0 if at the end
    let g:colors_idx = (g:colors_idx + 1) % len(g:my_colorschemes)

    " Get the name from the list
    let l:theme = g:my_colorschemes[g:colors_idx]

    " Apply the colorscheme
    execute 'colorscheme ' . l:theme

    " Print a message so you know which one is active
    redraw
    echo "Colorscheme: " . l:theme

    " if &background ==# 'dark'
    "     set background=light
    " else
    "     set background=dark
    " endif
endfunction

" Enable termdebug plugin for debugging.
packadd! termdebug

" Substitute the build-in grep with git grep.
let &grepprg = "git --no-pager grep --no-color -n $*"

" When grep is completed open automatically the quickfix window.
autocmd QuickFixCmdPost grep copen


" Force the quickfix window to occupy the full width at the bottom
autocmd FileType qf wincmd J

function! MyGrep()
    silent! exec "cd $PWD"
    execute 'grep! ' . input('Grep for: ')
endfunction

nnoremap mg :call MyGrep()<CR>


" Under your project's root directory create the tags as follows:
" ctags --languages=Python,C,C++ -R -f tagsall . /usr/include /usr/local/include
set tags=./tags;/


" Don't automatically trigger the autocomplete.
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

" The following are needed to load the project level .vimrc where
" you can set the headers path and other project specific settings.
set exrc      " Allow project-specific Vim configs
set secure    " Prevent unsafe commands in local configs

" Under your project's root directory create the .vimrc following this format:
" set path=.,/usr/local/include,/usr/include,../headers
"
"
" Map j k to move up and down the omnicompletion list.
"
" Move down in popup (omnicompletion) menu with j
inoremap <expr> j pumvisible() ? "\<C-n>" : "j"

" Move up in popup (omnicompletion) menu with k
inoremap <expr> k pumvisible() ? "\<C-p>" : "k"

" Select current item in popup menu with Enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l
inoremap <C-h> <C-o>h
inoremap <C-b> <C-o>b

" Disable the auto insertion of comment leader when pressing Enter.
autocmd FileType * set formatoptions-=ro


set colorcolumn=81
autocmd BufWinEnter * setlocal colorcolumn=81

" Skip for vimgrep.
set wildignore+=*/myenv/*,*/build/*,*.tmp

" Set the grep program to git grep
" To use just grep the text you need.
set grepprg=git\ grep\ -n\ --column

" -----------------------------------------------------------------------------
" Auto-Project Path: Dynamically adds the project root to the search path.
"
" This function searches upward from the current file's directory to find
" a .git folder. If found, it recursively appends that root directory to
" the 'path' variable. This allows commands like 'gf' (go to file) and
" ':find' to locate headers or modules anywhere within the project tree
" (e.g., in headers/, src/, or tests/) regardless of where Vim was launched.
" -----------------------------------------------------------------------------
function! AddProjectToPath()
    let l:project_root = finddir('.git/..', expand('%:p:h') . ';')
    if l:project_root != ''
        execute 'setlocal path+=' . l:project_root . '/**'
    endif
endfunction

autocmd BufRead,BufNewFile * call AddProjectToPath()

python3 << EOF
"""Defines the run_selection function."""

import vim
import os
import re

def run_selection_without_quick_fix():
    """Runs the current selection in the current buffer."""

    # Save the current buffer before running
    vim.command('update')

    filepath = vim.current.buffer.name
    if not filepath:
        print("No file name associated with buffer.")
        return

    filename = os.path.basename(filepath)

    if not filename.endswith('.py'):
        print(filename, "Can only run python files.")
        return

    # Save all modified buffers before formatting
    vim.command('wa')

    if not filename.startswith('test'):
        # It is a python file, if not a test file just run it.
        cmd = 'execute "!python3 %"'
        vim.command(cmd)
        return

    # Is a test file, if the cursor is on a test function, run it
    # otherwise run all tests.

    row, col = vim.current.window.cursor
    lines = vim.current.buffer
    current_line = lines[row-1]

    test_func_name = None
    match = re.match(r"^def\s+(test_\w+)", current_line)
    if match:
        test_func_name = match.group(1)

    if test_func_name:
        vim.command( f'execute "!pytest %::{test_func_name} -s"')
    else:
        vim.command( 'execute "!pytest % -s"')

EOF


python3 << EOF
"""Defines the run_selection function."""

import vim
import os
import re

def run_selection():
    """Runs the selection and sends output to quickfix."""

    # Save the current buffer before running
    vim.command('update')

    filepath = vim.current.buffer.name
    if not filepath:
        print("No file name associated with buffer.")
        return

    filename = os.path.basename(filepath)

    if filename.endswith('.cu') or filename.endswith('.c'):
        vim.command(r'setlocal makeprg=make\ %:r')
        vim.command('setlocal errorformat&')
        vim.command('make')
        return

    if not filename.endswith('.py'):
        print(filename, "Can only run python, cuda or c files.")
        return

    # Save all modified buffers before formatting
    vim.command('wa')

    # Force the quickfix engine to treat ALL lines as plain output text.
    vim.command('setlocal errorformat=%m')

    if not filename.startswith('test'):
        vim.command(r'setlocal makeprg=python3\ %')
        return

    # Is a test file, if the cursor is on a test function, configure it
    row, col = vim.current.window.cursor
    lines = vim.current.buffer
    current_line = lines[row-1]

    test_func_name = None
    match = re.match(r"^def\s+(test_\w+)", current_line)
    if match:
        test_func_name = match.group(1)

    if test_func_name:
        vim.command(fr'setlocal makeprg=pytest\ %\::{test_func_name}\ -s')
    else:
        vim.command(r'setlocal makeprg=pytest\ %\ -s')

EOF

" Map to <leader>r

nnoremap <leader>r :python3 run_selection()<CR>:silent make<CR>:copen<CR>:cbottom<CR>:redraw!<CR>


"""""""""""" Adds the reformat functionality """""""""""""""""

python3 << EOF
"""Reformat the current python file."""
import os
import shutil
import vim

def reformat_file():
    """Reformat current python file."""
    filepath = vim.current.buffer.name
    if not filepath:
        print("No file name associated with buffer.")
        return

    filename = os.path.basename(filepath)

    if not filename.endswith('.py'):
        print(filename, "Can only reformat python files.")
        return

    # Save all modified buffers before formatting
    vim.command('wa')

    # Check if black is installed and available in PATH
    if not shutil.which('black'):
        print("Error: 'black' formatter is not installed or not in PATH.")
        return

    cmd = 'execute "!black %"'
    vim.command(cmd)
    vim.command('e!')
EOF

" Map to <leader>f
nnoremap <leader>f :python3 reformat_file()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""  Scratch Pad  """""""""""""""""""""""""""""
function! ScratchPad()
" Open a scratch window
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

nnoremap <silent> <leader>s :call ScratchPad()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" By default start having search highlight on.
set hlsearch
" Highlight search terms <leader> h
nnoremap <silent> <leader>h :set hlsearch!<CR>

" In fugive, open diff in vertical split
set diffopt+=vertical


" Clipbooard settings.
set clipboard=unnamedplus
set incsearch

" Toggle between a source file and its corresponding test file.
"
" Description:
"   If called on a source file (e.g., parent/myprog.py), it opens
"   parent/tests/test_myprog.py. If called on a test file
"   (e.g., parent/tests/test_myprog.py), it navigates back to parent/myprog.py.
"   If the target file does not exist, an error message is displayed.
function! ToggleTestFile()
    let curr_file = expand('%:p')
    if empty(curr_file)
        echo "No file open."
        return
    endif

    let filename = expand('%:t')
    let dir = expand('%:p:h')

    if filename =~ '^test_'
        " Currently in a test file, locate the corresponding source file
        let src_filename = substitute(filename, '^test_', '', '')
        let parent_dir = fnamemodify(dir, ':h')
        let target_file = parent_dir . '/' . src_filename
    else
        " Currently in a source file, locate the corresponding test file
        let target_file = dir . '/tests/test_' . filename
    endif

    if filereadable(target_file)
        execute 'edit ' . fnameescape(target_file)
    else
        echo "Target file not found: " . target_file
    endif
endfunction

nnoremap <leader>t :call ToggleTestFile()<CR>

" Split window vertically
nnoremap <leader>v <C-w>v

" Split window horizontally
nnoremap <leader>w <C-w>s

" Close the current window
nnoremap <leader>c :q<CR>

" Markdown highlighting
" Remove bright red background highlights from underscores in Markdown files
" Used for some color schemes like elflord where the underscore is highlighted
" with a bright red background.
highlight markdownItalicDelimiter ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight markdownError ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE


" Window navigation using Shift + hjkl

nnoremap <C-Up>    <C-w>k
nnoremap <C-Down>  <C-w>j
nnoremap <C-Left>  <C-w>h
nnoremap <C-Right> <C-w>l
