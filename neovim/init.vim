" ---------------------------
" Plugins
" ---------------------------
call plug#begin()

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/preservim/nerdtree' ", {'on': 'NERDTreeToggle'}
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/preservim/tagbar', {'on': 'TagbarToggle'} " Tagbar for code navigation
Plug 'https://github.com/junegunn/fzf.vim' " Fuzzy Finder, Needs Silversearcher-ag for :Ag
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/navarasu/onedark.nvim'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/lepture/vim-jinja'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/matze/vim-move'
Plug 'voldikss/vim-floaterm'
Plug 'vim-python/python-syntax'
Plug 'alvan/vim-closetag'

" ---------------------------
" New plugins for snippets & autocompletion
" ---------------------------
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'neovim/nvim-lspconfig'

call plug#end()

" ---------------------------
" General Configuration
" ---------------------------
set number
set relativenumber
set mouse=a
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set encoding=UTF-8
set visualbell
set scrolloff=5

:colorscheme onedark
let g:airline_theme='onedark'

" NERDTree Configuration
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:python_highlight_all = 1

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> :UndotreeToggle<CR>

" VIM AIRLINE CONFIGURATION
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text'
    \]

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Tagbar
nmap <F6> :TagbarToggle<CR>

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

nnoremap <F3> :noh<CR>

" Floaterm
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
nnoremap <F5> :w<CR>:FloatermNew --autoclose=0 python3 %<CR>

let g:coc_disable_startup_warning = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

:map <MiddleMouse> <Nop>
:imap <MiddleMouse> <Nop>
:map <2-MiddleMouse> <Nop>
:imap <2-MiddleMouse> <Nop>
:map <3-MiddleMouse> <Nop>
:imap <3-MiddleMouse> <Nop>
:map <4-MiddleMouse> <Nop>
:imap <4-MiddleMouse> <Nop>

" ---------------------------
" LuaSnip + nvim-cmp + LSP Configuration
" ---------------------------
lua << EOF
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, {'i','s'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {'i','s'}),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- LSP Servers
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup{}
-- JavaScript / TypeScript / React / Node.js
lspconfig.ts_ls.setup{}
-- HTML / CSS
lspconfig.html.setup{}
lspconfig.cssls.setup{}
-- Java
lspconfig.jdtls.setup{}
EOF

" ---------------------------
" Filetype extensions for snippets
" ---------------------------
autocmd FileType html,htm,xml,jinja,lua,python,javascript,typescript,css,scss,java,jsx,tsx,node lua require('luasnip').filetype_extend('html', {'html'})
autocmd FileType javascript,typescript,jsx,tsx,node lua require('luasnip').filetype_extend('javascript', {'javascript','typescript'})
autocmd FileType python lua require('luasnip').filetype_extend('python', {'python'})
autocmd FileType java lua require('luasnip').filetype_extend('java', {'java'})
autocmd FileType css,scss lua require('luasnip').filetype_extend('css', {'css','scss'})

" ---------------------------
" Auto Closing Tags Configuration
" ---------------------------
" Enable for HTML, XML, JSX, and TSX
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsx,*.tsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,xml,javascriptreact,typescriptreact'
let g:closetag_xhtml_filetypes = 'xhtml,javascriptreact,typescriptreact'
let g:closetag_regions = {
\ 'html' : 'html',
\ 'xml'  : 'xml',
\ 'javascriptreact' : 'jsxRegion,tsxRegion',
\ 'typescriptreact' : 'jsxRegion,tsxRegion'
\}

" Map <C-]> to jump between tag start and end
nmap <C-]> :call CloseTag()<CR>

" Enable case-sensitive tag matching (optional, recommended)
let g:closetag_enable_case_insensitive = 0

" Insert closing quote automatically
let g:closetag_auto_quickquote = 1

" Close tags immediately after typing '>'
let g:closetag_auto_close = 1

