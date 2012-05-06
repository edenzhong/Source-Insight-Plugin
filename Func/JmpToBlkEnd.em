


macro JmpToBlkEnd()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	// to select a block
	if(sel.fExtended)
	{
		text = GetBufSelText (hbuf)
		if( "{" != text[0] )
		{
			Select_Block
		}
	}
	else
	{
		Select_Block
	}

	// check if the blk selected.
	sel = GetWndSel (hwnd)
	text = GetBufSelText (hbuf)
	
	if( "{" != text[0] )
	{
		return;
	}

	Jump_To_Match
	cursor_right
}

