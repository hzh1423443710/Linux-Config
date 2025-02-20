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
