" OmniCppComplete initialization
call omni#cpp#complete#Init()
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|pclose|endif
