set number
set relativenumber
set cursorline
set mouse+=a

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

" 安装插件管理器 vim-plug
" vim-plug 的安装目录为 ~/.local/share/nvim/site/autoload/plug.vim
call plug#begin('~/.local/share/nvim/plugged')

" 在这里添加您想要安装的插件，例如：
" Plug '插件名称'
Plug 'catppuccin/nvim'			"主题
Plug 'numToStr/Comment.nvim'	"注释
Plug 'preservim/nerdtree'		"文件浏览器

call plug#end()

colorscheme catppuccin

lua << EOF
require('Comment').setup()
EOF
