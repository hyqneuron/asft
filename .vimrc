"=========================
"=========================
"BASIC SETTINGS
"=========================
"=========================
set nu linebreak wrap!
set smartindent
set hlsearch
set autochdir
set clipboard=unnamed
set go-=T
map <F5> :NERDTreeToggle<CR>
filetype plugin on
command! ReloadVIMRC source $MYVIMRC
command! EditVIMRC tabe ~/.vimrc
hi PmenuSel ctermfg=black ctermbg=white

"============
"OmniCppComplete
"============
set completeopt=menuone,menu,longest,preview
command! BuildTags !ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q 
map <C-F12> :BuildTags<CR>
au BufRead,BufNewFile *.cpp set tags+=~/.vim/tags/cpp
au BufRead,BufNewFile *.h set tags+=~/.vim/tags/cpp
let OmniCpp_NamespaceSearch = 2 "2: search in all buffers. 1: search in current buffer only
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_SelectFirstItem = 2 " select first pop up item without inserting it to text
let OmniCpp_LocalSearchDecl = 1 " use smarter local definition search
let OmniCpp_DefaultNamespaces = ["std"]
if &ofu==""
	set omnifunc=syntaxcomplete#Complete
endif
"use ,, to triger local completion and .. to trigger omnifunc
imap ,, <c-x><c-n>
imap .. <c-x><c-o>

"Use arror keys to nativage the pop up menu
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"============
"Other completion related
"============
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

"============
"QuickMove
"============
imap <F2> <C-o>:call ToggleQuickMove()<CR>
map <F2> :call ToggleQuickMove()<CR>

"============
"Thought files autocmd
"============
au BufRead,BufNewFile t\d\+\.txt set ft=thought


"============
"Meta mapping
"============
" fix meta-keys which generate <Esc>a .. <Esc>z
let c='a'
while c <= 'z'
exec "set <M-".toupper(c).">=\e".c
	exec "imap \e".c." <M-".toupper(c).">"
	let c = nr2char(1+char2nr(c))
endw

"=========================
"=========================
"OPTIONAL SETTINGS
"=========================
"=========================

"============
"Toggle QuickMove
"============
"i: hjkl to move cursor
"n: jk to scroll down/up, th,tl to go to left/right tab

function! ToggleQuickMove()
	if !exists("s:imove")
		let s:imove=0 "zero: not enabled
	endif
	if s:imove
		map j gj
		map k gk
		iunmap j
		iunmap k
		iunmap h
		iunmap l
		unmap th
		unmap tl
		let s:imove = 0
		echo "QuickMove Off"
	else
		map j <C-e><Down>
		map k <C-y><Up>
		imap j <C-o>j
		imap k <C-o>k
		imap h <C-o>h
		imap l <C-o>l
		map th :tabp<CR>
		map tl :tabn<CR>
		let s:imove = 1
		echo "QuickMove On"
	endif
endfunction

"============
"Display Line Movement
"============
function! SetGMove()
	map j gj
	map k gk
	map <Up> gk
	map <Down> gj
endfunction
call SetGMove()
function! UnSetGMove()
	unmap j 
	unmap k 
	unmap <Up> 
	unmap <Down> 
endfunction

"============
"Margin Setting 
"============
function! SetMargins()
	130 vnew
	30 vnew
	wincmd l
endfunction

"============
"Window Switching
"============
function! SetWinSwitch()
	map <C-h> <C-w>h
	map <C-l> <C-w>l
	map <C-j> <C-w>j
	map <C-k> <C-w>k
endfunction

function! UnSetWinSwitch()
	unmap <C-h> 
	unmap <C-l>
	unmap <C-j>
	unmap <C-k>
endfunction
