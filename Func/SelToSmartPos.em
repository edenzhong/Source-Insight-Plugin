

macro SelToSmartBegin()
{
	var hbuf
	var ln
	var len
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)

	if ( len > 0 )
	{
		var hwnd
		var ori_sel
		hwnd =  GetCurrentWnd ()
		ori_sel = GetWndSel (hwnd)

		End_Of_Line
		Smart_Beginning_Of_Line

		var cur_sel
		cur_sel = GetWndSel(hwnd)
		if ( ori_sel.ichlim > cur_sel.ichfirst )
		{
			ori_sel.ichfirst = cur_sel.ichfirst
			SetWndSel (hwnd, ori_sel)
		}
	}
}

macro SelToSmartEnd()
{
	var hbuf
	var ln
	var len
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)

	if ( len > 0 )
	{
		var hwnd
		var ori_sel
		hwnd =  GetCurrentWnd ()
		ori_sel = GetWndSel (hwnd)

		Beginning_of_Line
		Smart_End_Of_Line

		var cur_sel
		cur_sel = GetWndSel(hwnd)
		if ( ori_sel.ichfirst < cur_sel.ichLim )
		{
			ori_sel.ichLim = cur_sel.ichLim
			SetWndSel (hwnd, ori_sel)
		}
	}
}


