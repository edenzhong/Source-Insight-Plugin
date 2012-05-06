
macro viDefaultSelect()
{
	Beginning_of_Selection
	
	var siarg
	siarg = GetCurSiArg()
	sel = siarg.sel

	// if select nothing, select cur char
	if ( !sel.fExtended )
	{
		// select one char
		ln = GetBufLnCur (siarg.hbuf)
		len = GetBufLineLength (siarg.hbuf, ln)
		if ( sel.ichFirst < len )
		{
			sel.ichLim = sel.ichFirst + 1
		}
		else
		{
			if ( len > 0 )
			{
				sel.ichFirst = sel.ichFirst -1
			}
		}
		SetWndSel (siarg.hwnd, sel)
	}
	return sel;
}
macro viCmd()
{
	cmd = ask("Command:")
	msg("not finish yet. lazy.")
}
macro viGetLeftCntInline(hbuf,cursel,curcnt)
{
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)
	
	cnt = len - cursel.ichfirst
	if ( cnt > curcnt )
	{
		return curcnt
	}
	else
	{
		return cnt
	}
}
macro viGetVaildNum(numvar)
{
	num = getenv(numvar)
	if ( num == "" )
	{
		return 1
	}
	return num
}
macro viGetTotalNum()
{
	base = viGetVaildNum("vinum")
	combo = viGetVaildNum("cmdvinum")
	total = base * combo
	return total
}
macro viResetCmdNum()
{
	PutEnv("vinum","")
	PutEnv("cmdvinum","")
	putenv("cmdvinum_bak",1)
}
macro viCmd_DelWithMotionLineDown()
{
	//select_line
	Beginning_of_Line
	Select_Line_Down
	Select_Line_Down
	vinum = viGetTotalNum()
	 
	while(vinum > 1 )
	{
		Select_Line_Down
		vinum = vinum - 1
	}
	cut
	viResetCmdNum()
}
macro viCmd_DelToEndOfLine()
{
	Beginning_of_selection
	Select_To_End_Of_Line
	vinum = viGetVaildNum("vinum")
	 
	while(vinum > 1 )
	{
		select_char_right
		Select_To_End_Of_Line
		vinum = vinum - 1
	}
	Delete_Character
	putenv("vinum","")
	viDefaultSelect()
}
macro viCmd_CutLines()
{
	//select_line
	Beginning_of_Line
	Select_Line_Down
	vinum = viGetTotalNum()
	 
	while(vinum > 1 )
	{
		Select_Line_Down
		vinum = vinum - 1
	}
	cut
}
macro viCmd_Del(hwnd,hbuf,cursel,ch,basecmd)
{
	var vinum
	// delete to end of line
	if ( "$" == ch )
	{
		Beginning_of_selection
		Select_To_End_Of_Line
		vinum = viGetTotalNum()
		 
		while(vinum > 1 )
		{
			select_char_right
			Select_To_End_Of_Line
			vinum = vinum - 1
		}
		cut
		viResetCmdNum()
	}
	// delete line
	else if (("d" == ch ) && ("c" != basecmd))
	{
		viCmd_CutLines()
		viResetCmdNum()
	}
	// delete left char
	else if ( "h" == ch )
	{
		Beginning_of_Selection
		cursel = GetWndSel (hwnd)
		if ( cursel.ichfirst > 0 )
		{
			vinum = viGetTotalNum()
			if ( vinum > cursel.ichfirst )
			{
				vinum = cursel.ichfirst; 
			}
			
			while(vinum > 0 )
			{
				select_char_left
				vinum = vinum - 1
			}
			cut
			viDefaultSelect()
		}
		viResetCmdNum()
	}
	// delete right char
	else if ( "l" == ch )
	{
		Beginning_of_Selection
		cursel = GetWndSel (hwnd)
		ln = GetBufLineLength (hbuf, cursel.lnfirst)
		if ( ln > cursel.ichfirst )
		{
			var tmp
			tmp = ln - cursel.ichfirst
			vinum = viGetTotalNum()
			if ( vinum > tmp )
			{
				vinum = tmp
			}
			
			while(vinum > 0 )
			{
				select_char_right
				vinum = vinum - 1
			}
			cut
			viDefaultSelect()
		}
		viResetCmdNum()
	}
	// delete line down
	else if ( "j" == ch )
	{
		viCmd_DelWithMotionLineDown()
	}
	// delete line up
	else if ( "k" == ch )
	{
		vinum = viGetTotalNum()
		while(vinum>0)
		{
			cursor_up
			vinum = vinum - 1
		}
		viCmd_DelWithMotionLineDown()
	}
	else
	{
		msg("err")
	}
}
macro viCmd_GotoLine(hwnd,hbuf,cursel)
{
	var vinum
	vinum = GetEnv("vinum")

	// go to that line
	if ( vinum != "")
	{
		if ( vinum > 0 )
		{
			// because the line number show in the editor is start from 1,
			// but the navigate line number start from 0. 
			// we must handle this off-by-one case.
			vinum = vinum - 1 
		}
		ln = GetBufLineCount (hbuf)
		if ( ln < vinum )
		{
			msg("line exceed!")
		}
		else
		{
			ln = vinum
			cursel.lnfirst = ln
			cursel.lnlast = ln
			cursel.ichfirst = 0
			cursel.ichlim = 1
			setwndsel(hwnd,cursel)
			
			ScrollWndToLine (hwnd, 0)
			lncnt = GetWndLineCount (hwnd)
			lncnt = lncnt / 2
			if ( ln > lncnt )
			{
				ln = ln - lncnt
			}
			else
			{
				ln = 0
			}
			ScrollWndToLine (hwnd, ln)
		}
	}
	// go to last line
	else
	{
		ln = GetBufLineCount (hbuf)
		cursel.lnfirst = ln
		cursel.lnlast = ln
		cursel.ichfirst = 0
		cursel.ichlim = 1
		setwndsel(hwnd,cursel)
		
		ScrollWndToLine (hwnd, 0)
		lncnt = GetWndLineCount (hwnd)
		lncnt = lncnt-1
		if ( ln > lncnt )
		{
			ln = ln - lncnt
		}
		else
		{
			ln = 0
		}
		ScrollWndToLine (hwnd, ln)
	}
	putenv("vinum","")
}
macro viCmd_Goto1stNonBlankOfLine(hbuf,cursel)
{
	if ( GetBufLineLength (hbuf, cursel.lnfirst) > 0 )
	{
		end_of_line
		Smart_Beginning_of_Line
	}
	viDefaultSelect()
}
macro viCmd_IndentLeft(ch)
{
	if ( "<" == ch )
	{
		Beginning_of_selection
		Select_To_End_Of_Line
		vinum = viGetTotalNum()
		while(vinum>1)
		{
			select_char_right
			Select_To_End_Of_Line
			vinum = vinum - 1
		}
		indent_left
	}
	viDefaultSelect()
	viResetCmdNum()
}
macro viCmd_IndentRight(ch)
{
	if ( ">" == ch )
	{
		Beginning_of_selection
		Select_To_End_Of_Line
		vinum = viGetTotalNum()
		while(vinum>1)
		{
			select_char_right
			Select_To_End_Of_Line
			vinum = vinum - 1
		}
		indent_right
	}
	viDefaultSelect()
	viResetCmdNum()
}
macro viComboCmdProc(key)
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetCurrentBuf ()
	var cursel
	cursel = viDefaultSelect()

	var basecmd
	basecmd = getenv("basecmd")

	var ch
	ch = CharFromKey(key)

	var vinum

	// delete with motion
	if (( "d" == basecmd ) || ("c" == basecmd))
	{
		viCmd_Del(hwnd,hbuf,cursel,ch,basecmd)
	}
	else if ("<" == basecmd)
	{
		viCmd_IndentLeft(ch)
	}
	else if ( ">" == basecmd )
	{
		viCmd_IndentRight(ch)
	}
}

macro viBaseCmdProc()
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetCurrentBuf ()
	var cursel
	cursel = viDefaultSelect()

	var basecmd
	basecmd = getenv("basecmd")
	

	// modify with motion
	if ( "c" == basecmd )
	{
		cursor_right
		stop
	}
}
macro viInitCmdGetKey(basecmd)
{
	putenv("basecmd",basecmd)
	putenv("cmdvinum","")
	putenv("cmdvinum_bak","")
}
macro viCmdProc(key)
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetCurrentBuf ()
	var cursel
	cursel = viDefaultSelect()
	
	var ch
	ch = CharFromKey(key)

	var vinum
	
	// append after cursor
	if ( "a" == ch)
	{
		beginning_of_selection
		cursor_right
		stop
	}
	// append at end of line
	else if ( "A" == ch)
	{
		end_of_line
		stop
	}
	// move to previous word (stops at punctuation)
	// a bug here: when meet the very first byte of the file, this script stop
	else if ( "b" == ch )
	{
		Beginning_of_Selection
		Word_Left
		viDefaultSelect()
	}
	else if ( "B" == ch )
	{
		// page up
		if ( IsCtrlKeyDown(key) )
		{
			Beginning_of_Selection
			page_up
			viDefaultSelect()
		}
		//  move to previous word (skips punctuation)
		// a bug here: when meet the very first byte of the file, this script stop
		else
		{
			loop = 1
			while(loop)
			{
				Beginning_of_Selection
				Word_Left
				viDefaultSelect()

				cursel = GetWndSel (hwnd)
				str = GetBufLine (hbuf, cursel.lnFirst)
				if ( strlen(str) > 0 )
				{
					ch = strmid (str, cursel.ichFirst, cursel.ichFirst+1)
					if ( !isPunctuation(ch) )
					{
						loop = 0
					}
				}
				else
				{
					loop = 0
				}
			}
		}
	}
	// change text (m is movement)
	else if ( "c" == ch )
	{
		viInitCmdGetKey("c")
		return 1
	}
	// change text to end of line
	else if ( "C" == ch )
	{
		viCmd_DelToEndOfLine()
		cursor_right
		stop
	}
	// delete with motion
	else if ( "d" == ch )
	{
		viInitCmdGetKey("d")
		return 1
	}
	else if ( "D" == ch )
	{
		// half page down
		if ( IsCtrlKeyDown(key) )
		{
			Beginning_of_Selection
			Scroll_Half_Page_Down
			viDefaultSelect()
		}
		// delete to end of line
		else 
		{
			viCmd_DelToEndOfLine()
		}
	}
	// end of word (puncuation not part of word)
	else if ( "e" == ch )
	{
		
	}
	else if ( "E" == ch )
	{
		// Scroll Line Down
		if ( IsCtrlKeyDown(key) )
		{
			Scroll_Line_Down
			viDefaultSelect()
		}
		// end of word (punctuation part of word)
		else
		{
			
		}
	}
	// search char forward within current line
	else if ( "f" == ch )
	{
		ch = getchar()
		
		cursel = GetWndSel (hwnd)
		ln = GetBufLnCur (hbuf)
		len = GetBufLineLength (hbuf, ln)
		if ( len > cursel.ichfirst )
		{
			str = GetBufLine (hbuf, ln)
			str = strmid (str, cursel.ichFirst+1, len)
			idx = FindStr(str,ch)
			if ( idx >= 0 )
			{
				idx = idx + 1
				while(idx>0)
				{
					Cursor_Right
					idx = idx - 1
				}
				viDefaultSelect()
			}
		}
	}
	else if ( "F" == ch )
	{
		// page down
		if ( IsCtrlKeyDown(key) )
		{
			Beginning_of_Selection
			page_down
			viDefaultSelect()
		}
		// search char backward within current line
		else 
		{
			ch = getchar()
			cursel = GetWndSel (hwnd)
			if ( cursel.ichfirst > 0 )
			{
				ln = GetBufLnCur (hbuf)
				str = GetBufLine (hbuf, ln)
				str = strmid(str,0,cursel.ichfirst)
				idx = FindStrR(str,ch)
				step = cursel.ichfirst - idx;
				if ( step > 0 )
				{
					Beginning_of_Selection
					while(step>0)
					{
						Cursor_Left
						step = step -1
					}
					viDefaultSelect()
				}
			}
		}
	}
	else if ( "g" == ch )
	{
		ch = getchar()

		// go to first line
		if ( "g" == ch )
		{
			cursel.lnfirst = 0
			cursel.lnlast = 0
			cursel.ichfirst = 0
			cursel.ichlim = 1
			setwndsel(hwnd,cursel)
			ScrollWndToLine (hwnd, 0)
		}
		// go to def of the current cursor
		else if ( "d" == ch )
		{
			Beginning_of_Selection
			Jump_To_Definition
		}
	}
	else if ( "G" == ch )
	{
		viCmd_GotoLine(hwnd,hbuf,cursel)
	}
	// cursor left
	else if ( "h" == ch )
	{
		cursel = GetWndSel (hwnd)
		if ( cursel.ichFirst  > 0 )
		{
			Beginning_of_Selection
			Select_Char_Left
		}
	}
	else if ( "H" == ch )
	{
		lnfirst = GetWndVertScroll (hwnd)
		cursel = GetWndSel (hwnd)
		cursel.lnfirst = lnfirst
		cursel.lnlast = lnfirst
		str = get_pre_space(getbufline(hbuf,lnfirst))
		cursel.ichfirst = strlen(str)
		cursel.ichlim = cursel.ichfirst + 1
		setwndsel(hwnd,cursel)
	}
	// inserting text
	else if ( "i" == ch)
	{
		beginning_of_selection
		stop // insert text before cursor
	}
	else if ( "I" == ch)
	{
		beginning_of_line
		stop
	}
	// cursor down
	else if ( "j" == ch)
	{
		if ( GetBufLnCur (hbuf) < GetBufLineCount (hbuf) )
		{
			Cursor_down
			viDefaultSelect()
		}
	}
	// join end of line with next line (at <cr>)
	else if ( "J" == ch )
	{
		Join_Lines
	}
	// cursor up
	else if ( "k" == ch)
	{
		if ( GetBufLnCur (hbuf) > 0 )
		{
			Cursor_up
			viDefaultSelect()
		}
	}
	else if ( "K" == ch )
	{
		
	}
	// cursor right
	else if ( "l" == ch)
	{
		cursel = GetWndSel (hwnd)
		if ( cursel.ichLim < GetBufLineLength (hbuf, GetBufLnCur (hbuf)) )
		{
			Cursor_Right
			Select_Char_Right
		}
	}
	else if ( "L" == ch )
	{
		lncnt = GetWndLineCount (hwnd)
		if ( lncnt > 0 )
		{
			lncnt = lncnt - 1
		}
		lnlocate = GetWndVertScroll (hwnd)+ lncnt
		cursel = GetWndSel (hwnd)
		cursel.lnfirst = lnlocate
		cursel.lnlast = lnlocate
		str = get_pre_space(getbufline(hbuf,lnlocate))
		cursel.ichfirst = strlen(str)
		cursel.ichlim = cursel.ichfirst + 1
		setwndsel(hwnd,cursel)
	}
	// mark
	else if ( "m" == ch )
	{
		
	}
	// move cursor to the middle of current screen
	else if ( "M" == ch )
	{
		lncnt = GetWndLineCount (hwnd)
		if ( lncnt > 0 )
		{
			lncnt = lncnt / 2
		}
		lnlocate = GetWndVertScroll (hwnd)+ lncnt
		cursel = GetWndSel (hwnd)
		cursel.lnfirst = lnlocate
		cursel.lnlast = lnlocate
		str = get_pre_space(getbufline(hbuf,lnlocate))
		cursel.ichfirst = strlen(str)
		cursel.ichlim = cursel.ichfirst + 1
		setwndsel(hwnd,cursel)
	}
	// search next
	else if ( "n" == ch )
	{
		Search_Forward
	}
	// search prev
	else if ( "N" == ch )
	{
		Search_Backward
	}
	// insert line
	else if ( "o" == ch)
	{
		end_of_line
		enter
		stop
	}
	// insert line befor current line
	else if ( "O" == ch)
	{
		insert_line
		stop
	}
	// paste after the cursor
	else if ( "p" == ch )
	{
		//End_of_Selection
		cursor_right
		Paste
		viDefaultSelect()
	}
	// paste before the cursor
	else if ( "P" == ch )
	{
		Beginning_of_Selection
		Paste
		viDefaultSelect()
	}
	// record macro. i don't use it
	else if ( "q" == ch )
	{
		
	}
	// switch to ex mode. what is it???
	else if ( "Q" == ch )
	{
		
	}
	// replace char
	// we can not use the state machine, because the char which to be
	// replace to might be a number.
	else if ( "r" == ch )
	{
		ch = getchar()
		vinum = viGetVaildNum("vinum")
		Beginning_of_Selection
		ln = GetBufLnCur (hbuf)
		len = GetBufLineLength (hbuf, ln)
		if ( len - cursel.ichfirst >= vinum )
		{
			while(vinum>0)
			{
				select_char_right
				vinum = vinum - 1
				SetBufSelText(hbuf, ch)
			}
		}
		viDefaultSelect()
		viResetCmdNum()
	}
	// switch to over-write mode.
	// but i don't know how to implement it in source insight
	else if ( "R" == ch )
	{
		
	}
	// delete char and insert
	else if ( "s" == ch )
	{
		Beginning_of_Selection
		vinum = viGetVaildNum("vinum")
		ln = GetBufLnCur (hbuf)
		len = GetBufLineLength (hbuf, ln)
		if ( len - cursel.ichfirst < vinum )
		{
			vinum = len - cursel.ichfirst
		}
		while(vinum>0)
		{
			Delete_Character
			vinum = vinum - 1
		}
		stop
	}
	// delete lines and insert
	else if ( "S" == ch )
	{
		viCmd_CutLines()
		stop
	}
	// forward to character before char
	else if ( "t" == ch )
	{
		ch = getchar()
		ln = GetBufLnCur (hbuf)
		len = GetBufLineLength (hbuf, ln)
		if ( len > cursel.ichfirst )
		{
			str = GetBufLine (hbuf, ln)
			str = strmid (str, cursel.ichFirst+1, len)
			idx = FindStr(str,ch)
			if ( idx >= 0 )
			{
				while(idx>0)
				{
					Cursor_Right
					idx = idx - 1
				}
				viDefaultSelect()
			}
		}
	}
	//  backward to character after char
	else if ( "T" == ch )
	{
		ch = getchar()
		if ( cursel.ichfirst > 0 )
		{
			ln = GetBufLnCur (hbuf)
			str = GetBufLine (hbuf, ln)
			str = strmid(str,0,cursel.ichfirst)
			idx = FindStrR(str,ch)
			step = cursel.ichfirst - idx;
			if ( step > 0 )
			{
				while(step>0)
				{
					Cursor_Left
					step = step -1
				}
				viDefaultSelect()
			}
		}
	}
	// undo.
	// but it seems can not be implemented easily here.
	else if ( "u" == ch )
	{
		undo
	}
	else if ( "U" == ch )
	{
		// half page up
		if ( IsCtrlKeyDown(key) )
		{
			Beginning_of_Selection
			Scroll_Half_Page_Up
			viDefaultSelect()
		}
		else 
		{
			
		}
	}
	// visual mode
	// not implement well
	else if ( "v" == ch )
	{
		stop
	}
	// line visual mode
	// not implement well
	else if ( "V" == ch )
	{
		stop
	}
	// move to next word (stops at puncuation)
	// a bug here: when meet the last byte of the file, this script stop
	else if ( "w" == ch )
	{
		Beginning_of_Selection
		Word_Right
		viDefaultSelect()
	}
	//  move to next word (skips punctuation)
	// a bug here: when meet the last byte of the file, this script stop
	else if ( "W" == ch )
	{
		loop = 1
		while(loop)
		{
			Beginning_of_Selection
			Word_Right
			viDefaultSelect()

			cursel = GetWndSel (hwnd)
			str = GetBufLine (hbuf, cursel.lnFirst)
			if ( strlen(str) > 0 )
			{
				ch = strmid (str, cursel.ichFirst, cursel.ichFirst+1)
				if ( !isPunctuation(ch) )
				{
					loop = 0
				}
			}
			else
			{
				loop = 0
			}
		}
	}
	// delete char under cursor
	else if ( "x" == ch )
	{
		cursel = GetWndSel (hwnd)
		if ( GetBufLineLength (hbuf, cursel.lnfirst) > 0 )
		{
			Beginning_of_Selection
			select_char_right
			cut
			viDefaultSelect()
		}
	}
	// delete char before cursor
	else if ( "X" == ch )
	{
		cursel = GetWndSel (hwnd)
		if ( cursel.ichfirst > 0 )
		{
			Beginning_of_Selection
			select_char_life
			cut
			viDefaultSelect()
		}
	}
	else if ( "y" == ch )
	{
		ch = getchar()

		if ( "y" == ch )
		{
			Copy_Line
		}
	}
	else if ( "Y" == ch )
	{
		// Scroll Line Up
		if ( IsCtrlKeyDown(key) )
		{
			Scroll_Line_Up
			viDefaultSelect()
		}
		else
		{
			Copy_Line
		}
	}
	else if ( "z" == ch )
	{
		key = GetKey ()
		ch = CharFromKey (key)
		
		ln = GetBufLnCur (hbuf)
		// position line with cursor at top
//		if ( ConditionOr(("t" == ch),(13==key)))
		if ( ("t" == ch) || (13==key) )
		{
			ScrollWndToLine (hwnd, ln)
		}
		// position line with cursor at middle
//		else if ( ConditionOr(("z" == ch),("." == ch)) )
		else if ( ("z" == ch)||("." == ch))
		{
			ScrollWndToLine (hwnd, 0)
			lncnt = GetWndLineCount (hwnd)
			lncnt = lncnt / 2
			if ( ln > lncnt )
			{
				ln = ln - lncnt
			}
			else
			{
				ln = 0
			}
			ScrollWndToLine (hwnd, ln)
		}
		// position line with cursor at bottom
		// a bug here: sometimes off-by-one, i don't know why.
//		else if ( ConditionOr(("b" == ch),("-" == ch)) )
		else if(("b" == ch)||("-" == ch))
		{
			ScrollWndToLine (hwnd, 0)
			lncnt = GetWndLineCount (hwnd)
			lncnt = lncnt-1
			if ( ln > lncnt )
			{
				ln = ln - lncnt
			}
			else
			{
				ln = 0
			}
			ScrollWndToLine (hwnd, ln)
		}
		else
		{
			// err
			viResetCmdNum();
		}
	}
	else if ( "Z" == ch )
	{
		
	}
	else if ( " " == ch ) // space
	{
		if ( )
		Beginning_of_Selection
		Scroll_Half_Page_Down
		viDefaultSelect()
	}
	// jump to mark
	else if ( "`" == ch )
	{
		
	}
	// toggle case
	else if ( "~" == ch )
	{
		pos = cursel.ichfirst + 1
		vinum = viGetLeftCntInline(hbuf,cursel,viGetVaildNum("vinum"))
		while(vinum>1 )
		{
			select_char_right
			vinum = vinum - 1
			pos = pos + 1
		}
		toggle_case
		SetBufIns (hbuf, cursel.lnfirst, pos)
		viDefaultSelect();
		viResetCmdNum()
	}
	else if ( "!" == ch )
	{
		
	}
	else if ( "\@" == ch )
	{
		
	}
	else if ( "#" == ch )
	{
		viPlusSeachCurWordR()
		viDefaultSelect()
		viResetCmdNum()
	}
	// end of line
	else if ( "$" == ch )
	{
		end_of_line
		viDefaultSelect()
	}
	// goto matching parenthesis () {} []
	else if ( "%" == ch )
	{
		jump_to_match
		viDefaultSelect()
	}
	// goto first non-blank char on line
	else if ( "^" == ch )
	{
		viCmd_Goto1stNonBlankOfLine(hbuf,cursel)
	}
	else if ( "&" == ch )
	{
		
	}
	// read the string nder the cursor and go to next occurrence
	// a bug here: the highlight might be toggled every time.
	else if ( "*" == ch )
	{
		viPlusSeachCurWord()
		viDefaultSelect()
		viResetCmdNum()
	}
	else if ( "(" == ch )
	{
		
	}
	else if ( ")" == ch )
	{
		
	}
	// goto first char on prev line
	else if ( "-" == ch )
	{
		cursor_up
		viCmd_Goto1stNonBlankOfLine(hbuf,cursel)
	}
	else if ( "_" == ch )
	{
		viCmd_Goto1stNonBlankOfLine(hbuf,cursel)
	}
	else if ( "=" == ch )
	{
		
	}
	// goto first char on next line
	else if ( "+" == ch )
	{
		cursor_down
		viCmd_Goto1stNonBlankOfLine(hbuf,cursel)
	}
	else if ( "\\" == ch )
	{
		
	}
	// column n of current line
	else if ( "|" == ch )
	{
		vinum = viGetVaildNum("vinum")
		ln = GetBufLnCur (hbuf)
		len = GetBufLineLength (hbuf, ln)
		if ( vinum > len )
		{
			vinum = len
		}
		vinum = vinum - 1
		Beginning_of_Line
		while ( vinum > 0 )
		{
			vinum = vinum - 1
			cursor_right
		}
		viDefaultSelect()
		viResetCmdNum()
	}
	else if ( "[" == ch )
	{
		
	}
	else if ( "]" == ch )
	{
		
	}
	else if ( "{" == ch )
	{
		
	}
	else if ( "}" == ch )
	{
		
	}
	else if ( ";" == ch )
	{
		
	}
	else if ( ":" == ch )
	{
		viCmd()
	}
	else if ( "'" == ch )
	{
		
	}
	else if ( "\"" == ch )
	{
		
	}
	else if ( "," == ch )
	{
		
	}
	else if ( "<" == ch )
	{
		viInitCmdGetKey("<")
		return 1
	}
	else if ( "." == ch )
	{
		
	}
	else if ( ">" == ch )
	{
		viInitCmdGetKey(">")
		return 1
	}
	else if ( "/" == ch )
	{
		str = ask("Search forward:")
	}
	else if ( "?" == ch )
	{
		str = ask("Search backward:")
	}
	else if ( "0" == ch )
	{
		Beginning_of_Line
		viDefaultSelect()
	}
	return 0
}
macro vimod()
{
	var vinum
	PutEnv("vinum","")

	var cmdvinum
	PutEnv("cmdvinum","")
	putenv("cmdvinum_bak",1)

	var curmod
	curmod = "nor_get_key"

	var ch
	var key
	var loop

	//StartMsg ("now is vi mode")


//	viDefaultSelect()
	while(1)
	{
		if ( "nor_get_key" == curmod )
		{
			viDefaultSelect()
			key = getkey()
			ch = CharFromKey(key)
			if ( isnumber(ch) )
			{
				curmod = "nor_num_record"
				if ( "0" == ch )
				{
					vinum = getenv("vinum")
					if ( vinum == "" )
					{
						curmod = "cmd_proc"
					}
				}
			}
			else
			{
				curmod = "cmd_proc"
			}
		}
		else if ( "nor_num_record" == curmod )
		{
			vinum = getenv("vinum")
			vinum = cat(vinum,ch)
			putenv("vinum",vinum)
			curmod = "nor_get_key"
		}
		else if ( "cmd_proc" == curmod )
		{
			if ( viCmdProc(key) )
			{
				curmod = "cmd_get_key"
			}
			else
			{
				curmod = "num_reduce"
			}
		}
		else if ( "num_reduce" == curmod )
		{
			vinum = getenv("vinum")
			if ( vinum != "" )
			{
				if ( vinum > 0 )
				{
					vinum = vinum - 1
					putenv("vinum",vinum)
				}

				if ( vinum > 0 )
				{
					curmod = "cmd_proc"
				}
				else
				{
					curmod = "nor_get_key"
					PutEnv("vinum","")
				}				
			}
			else
			{
				curmod = "nor_get_key"
			}
		}
		else if ( "cmd_get_key" == curmod )
		{
			key = getkey()
			ch = CharFromKey(key)
			if ( isnumber(ch) )
			{
				curmod = "cmd_num_record"
			}
			else
			{
				curmod = "combo_cmd_proc"
				vinum = getenv("cmdvinum")
				if ( vinum == "" )
				{
					putenv("cmdvinum_bak",1)
				}
				else
				{
					putenv("cmdvinum_bak",vinum)
				}
			}
		}
		else if ( "cmd_num_record" == curmod )
		{
			vinum = getenv("cmdvinum")
			vinum = cat(vinum,ch)
			putenv("cmdvinum",vinum)
			curmod = "cmd_get_key"
		}
		else if ( "combo_cmd_proc" == curmod )
		{
			viComboCmdProc(key)
			curmod = "combo_num_reduce"
		}
		else if ( "combo_num_reduce" == curmod )
		{
			vinum = getenv("cmdvinum")
			if ( vinum != "" )
			{
				if ( vinum > 0 )
				{
					vinum = vinum - 1
					putenv("cmdvinum",vinum)
				}
				if ( vinum > 0 )
				{
					curmod = "combo_cmd_proc"
				}
				else
				{
					curmod = "base_cmd_proc"
				}
			}
			else
			{
				curmod = "base_cmd_proc"
			}
		}
		else if ( curmod == "base_cmd_proc" )
		{
			viBaseCmdProc()
			curmod = "base_num_reduce"
		}
		else if ( curmod == "base_num_reduce" )
		{
			vinum = getenv("vinum")
			if ( vinum != "" )
			{
				if ( vinum > 0 )
				{
					vinum = vinum - 1
					putenv("vinum",vinum)
				}
				if ( vinum > 0 )
				{
					curmod = "reset_combo_key_num"
				}
				else
				{
					curmod = "nor_get_key"
					PutEnv("vinum","")
				}
			}
			else
			{
				curmod = "nor_get_key"
			}
		}
		else if ( curmod == "reset_combo_key_num" )
		{
			curmod = "combo_cmd_proc"
			vinum = getenv("cmdvinum_bak")
			putenv("cmdvinum",vinum)
		}
		else
		{
			msg("err")
			stop
		}
	}
}

