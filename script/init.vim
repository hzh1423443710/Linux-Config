set number
set relativenumber
set cursorline
set mouse+=a

" 使用系统剪切板
set clipboard=unnamedplus
" 上下窗口边缘至少保留5行
set scrolloff=5

" 显示vim模式(默认开启)
set showmode 
" 显示状态行,如文件路径(默认为2)
set laststatus=2
" 右下角显示光标位置
set ruler

syntax enable
" 文件类型检查
filetype indent on

" 高亮括号
set showmatch
" 高亮匹配
set hlsearch
" Enable searching as you type, rather than waiting till you press enter.
set incsearch
" 禁用响铃
set noerrorbells visualbell t_vb=

" 不兼容vi
set nocompatible
" 编码
set encoding=utf-8  

" 自动缩进
set autoindent
" 缩进
set tabstop=4
" tab转为多少空格
"set expandtab
"set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" visual模式下复制
vnoremap <C-c> "+y      
" 保存
noremap <C-s> :w<CR>    
" 退出vim
" nnoremap <Space>ww :q<CR>
nnoremap <A-w> :q<CR>
" 命令模式
nnoremap <F2> :
" 复制
vnoremap <C-c> "+y

"颜色主题
"colorscheme zaibatsu
colorscheme sorbet

