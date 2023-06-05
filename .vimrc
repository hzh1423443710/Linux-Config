" .vimrc
" 相对行号+高亮
set number
set relativenumber
set cursorline
" 显示状态栏
set laststatus=2
" 显示光标位置(状态栏)
set ruler
" 主题
colorscheme ron

" 高亮括号
set showmatch
" 高亮匹配
set hlsearch
" 调到第一个匹配位置
set incsearch

" 不兼容vi
set nocompatible
" 语法高亮
syntax on
" 底部显示模式
set showmode
" 支持鼠标
"set mouse=a
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

" 不创建交换文件
set noswapfile
" 记录历史操作1000
set history=1000
" 文件监视
set autoread
