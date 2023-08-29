set number
set relativenumber
set cursorline
" 显示状态栏
set showmode
" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
set ruler
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
syntax on
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
" 设置快捷键
noremap <F8> :wa<CR> :sh<CR>
noremap <F4> :wa<CR>
noremap <F5> :wa<CR> :make<CR><CR><CR>
" 添加注释
noremap <F2> :normal ^i// <CR> :normal ^<CR>  
" 删除注释
noremap <F3> :normal ^3x <CR> :normal ^<CR>


call plug#begin('~/.vim/plugged')

Plug 'ycm-core/YouCompleteMe'
Plug 'ycm-core/ycmd'
Plug 'preservim/nerdtree'

call plug#end()


" 激活 YouCompleteMe 插件
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

" 设置补全触发键
let g:ycm_key_invoke_completion = '<C-Space>'

" 设置代码补全的引擎和语言服务器
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

let g:ycm_clangd_binary_path = 'clangd'        " clangd 可执行文件的路径
let g:ycm_clangd_uses_ycmd_caching = 0         " 禁用 YCM 的缓存，使用 clangd 自己的缓存
let g:ycm_clangd_debug = 0                     " 关闭调试信息

