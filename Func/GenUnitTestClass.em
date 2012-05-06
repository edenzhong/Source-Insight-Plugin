
macro GenUnitTestClass()
{
	// get current word as the class name
	var hwnd
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
	{
		return
	}
	var hbuf
	hbuf = GetWndBuf(hwnd)

	Beginning_of_Selection
	Select_Word

	var sel
	sel = GetWndSel(hwnd)
	var className
	szLine = GetBufLine (hbuf, sel.lnfirst)
	className = strmid(szLine,sel.ichfirst,sel.ichlim)
	
	// make test class as Test{class name}
	var testClassName
	testClassName = cat("Test_",className);

	// generate cpp
	var srcFileName
	srcFileName = cat(testClassName,".cpp")
	var srcFileHdl
	srcFileHdl = NewBuf(srcFileName)
	SetCurrentBuf (srcFileHdl)
	PutEnv("sepcialReq","|unit test class|")
	ins_file_header()

	var headFileName
	headFileName = cat(testClassName,".h")
	var headFileHdl
	headFileHdl = NewBuf(headFileName)
	SetCurrentBuf (headFileHdl)
	PutEnv("sepcialReq","|fix hpp|unit test class|")
	ins_file_header()
}

