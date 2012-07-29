/*
这个模块用于头文件和源文件间切换
该模块的主函数是SwWnd,其他函数皆为辅助子函数
本来打算做到不区分大小写，但因为大写字母和
小写字母正好分别在下划线的两边，因此用二分法
查找的时候遇到列表里有下划线的文件就容易导致
查找失败，因此还是区分大小写。
*/

// 激活指定的文件.
// 用于在找到对应的文件后,激活该文件
// opfl : 要被激活的文件
macro ActSpecFile(opfl)
{
	var cobuf;
	var hwnd;
	cobuf = GetFileHandle(opfl)
			
	if ( hnil != cobuf)
	{
		SetCurrentBuf (cobuf)
		
		hwnd = GetWndHandle(cobuf)
		if ( hnil == hwnd )
		{
			newwnd(cobuf)
			hwnd = GetWndHandle(cobuf)
			if ( hnil == hwnd )
			{
				msg("should not come hrer...")
				return 0
			}
		}
		SetCurrentWnd(hwnd)
		return 1
	}
	else
	{
		// check if the file not in project, but it is opened in cache.
		var cwnd
		cwnd = WndListCount ()
		var iwnd
		iwnd = 0
		while (iwnd < cwnd)
		{
			hwnd = WndListItem(iwnd)
			var hbuf
			hbuf = GetWndBuf (hwnd)
			var filename
			filename = GetBufName (hbuf)
			filename = GetFileNameFromFullPath(filename)
			if ( opfl == filename)
			{
				SetCurrentWnd(hwnd)
				return 1;
			}
			iwnd = iwnd + 1
		}
	}
	return 0
}

//switch to coressponding window
macro SwWnd()
{
	var hwnd;
	var hbuf;
	var filename;
	var len
	var ichLim
	var opfl
	var tmp
	var ichFirst
	var cobuf
	
	hbuf = GetCurrentBuf ()
	filename = GetBufName (hbuf)
	filename = GetFileNameFromFullPath(filename)
	len = strlen (filename)
	filename = tolower (filename)
	
	ichLim = len;
	if ( len > 4 )
	{
		ichFirst = len - 4;
		tmp = strmid (filename, ichFirst, ichLim);
		if ( ".cpp" == tmp )
		{
			// check the corresponding h file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"h");

			if ( ActSpecFile(opfl) )
			{
				return;
			}

			// if h file not found, check hpp file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"hpp");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found header file in project!")
			}
		}
	}
	if ( len > 2 )
	{

		ichFirst = len - 2;
		tmp = strmid (filename, ichFirst, ichLim);
		if ( ".h" == tmp )
		{
			// check the corresponding c file
			opfl = strmid (filename, 0, ichFirst +1)
			opfl = cat(opfl,"c");
			if ( ActSpecFile(opfl) )
			{
				return
			}

			// if c file not found, check corresponding cpp file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"cpp");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found source file in project!")
			}
			return ;
		}
		
		if ( ".c" == tmp )
		{
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"h");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found header file in project!")
			}
			return;
		}
	}
}


