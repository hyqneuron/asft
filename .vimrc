"=========================
"=========================
"BASIC SETTINGS
"=========================
"=========================
set nu linebreak
set display=lastline
set tw=0
set wm=0
set smartindent
filetype plugin on
command! ReloadVIMRC source $MYVIMRC

"============
"OmniCppComplete
"============
set completeopt=menuone,menu,longest,preview
command! BuildTags !ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q 
set tags+=~/.vim/tags/cpp
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



"============
"QuickMove
"============
imap <F2> <C-o>:call ToggleInsertMove()<CR>
map <F2> :call ToggleQuickMove()<CR>

"============
"Thought files autocmd
"============
au BufRead,BufNewFile t\d\+\.txt set ft=thought


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
	imap <Up> <C-o>gk
	imap <Down> <C-o>gj
endfunction
call SetGMove()
function! UnSetGMove()
	unmap j 
	unmap k 
	unmap <Up> 
	unmap <Down> 
	iunmap <Up> 
	iunmap <Down> 
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


