macro ExpandClass()
{
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
	{
		return
	}
	hbuf = GetWndBuf(hwnd)

	Beginning_of_Selection
	Select_Word

	sel = GetWndSel(hwnd)
	var className
	szLine = GetBufLine (hbuf, sel.lnfirst)
	className = strmid(szLine,sel.ichfirst,sel.ichlim)

	chTab = CharFromAscii(9)
	ich = 0
	while (szLine[ich] == " " || szLine[ich] == chTab)
	{
		ich = ich + 1
	}
	baseIndent = strmid(szLine, 0, ich)
	plusIndent = IndentSign();

	var ln
	ln = sel.lnfirst
	PutBufLine (hbuf,ln,"@baseIndent@class @className@")
	InsBufLine(hbuf,ln + 1,"@baseIndent@{")
	InsBufLine(hbuf,ln + 2,"@baseIndent@@plusIndent@public:")
	InsBufLine(hbuf,ln + 3,"@baseIndent@@plusIndent@@plusIndent@@className@();")
	InsBufLine(hbuf,ln + 4,"@baseIndent@@plusIndent@@plusIndent@virtual ~@className@();")
	InsBufLine(hbuf,ln + 5,"@baseIndent@@plusIndent@@plusIndent@###")
	InsBufLine(hbuf,ln + 6,"@baseIndent@@plusIndent@private:")
	InsBufLine(hbuf,ln + 7,"@baseIndent@@plusIndent@@plusIndent@###")
	InsBufLine(hbuf,ln + 8,"@baseIndent@};")

	sel.lnLast = sel.lnFirst
	sel.ichFirst = 0
	sel.ichLim = 0
	
	SetWndSel(hwnd, sel)
	LoadSearchPattern("###", true, false, false);
	Search_Forward
}

