set number
set relativenumber
set cursorline
" 显示状态栏
set showmode
" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
set ruler
syntax enable
colorscheme koehler
set mouse+=a

" 高亮括号
set showmatch
" 高亮匹配
set hlsearch
" Enable searching as you type, rather than waiting till you press enter.
set incsearch
" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" 不兼容vi
set nocompatible
" 编码
set encoding=utf-8  
" 启用256色
set t_Co=256
" 文件类型检查
filetype indent on

" 自动缩进
set autoindent
" 缩进
set tabstop=4
" tab转为多少空格
"set expandtab
"set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" 按键绑定
vnoremap <C-c> "+y      " visual模式下复制
noremap <C-s> :w<CR>    " 保存
