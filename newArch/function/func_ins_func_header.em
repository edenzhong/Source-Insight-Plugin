
macro func_ins_func_header()
{
	// get current symbol
	var hwnd
	hwnd = GetCurrentWnd()

	var hbuf
	hbuf = GetCurrentBuf()

	var func_name
	func_name = GetCurSymbol()
	var func
	func = GetSymbolLocation (func_name)

	var cur_file_name
	cur_file_name = getbufname(hbuf)
	if ( func.File != cur_file_name )
	{
		msg("the symbol entity not in current file")
		return
	}
	
	var func_inf
	func_inf = get_func_info(func)
	if ( nil == func_inf )
	{
		return
	}

	var ln
	ln = func.lnFirst
	// gen header
	InsBufLine(hbuf,ln,"/*!")
	ln = ln + 1;InsBufLine(hbuf,ln,"\@brief ###")
	ln = ln + 1;InsBufLine(hbuf,ln,"")
	
	
	// return type
	if ( "void" == func_inf.return_type )
	{
		ln = ln + 1;InsBufLine(hbuf,ln,"\@return void")
	}
	else
	{
		ln = ln + 1;InsBufLine(hbuf,ln,"\@return ###")
	}

	// parameters
	var arg_cnt
	arg_cnt = get_arg_cnt(func_inf)
	if ( arg_cnt > 0 )
	{
		ln = ln + 1;InsBufLine(hbuf,ln,"")
		var arg
		var i
		i = 0
		while( i < arg_cnt)
		{
			arg = GetBufLine(func_inf.arg_name_buf,i)
			arg = cat("\@param ",arg)
			arg = cat(arg," : [###] ###")
			ln = ln + 1;InsBufLine(hbuf,ln,arg)
			i = i + 1
		}
	}

	// history
	ln = ln + 1;InsBufLine(hbuf,ln,"")
	ln = ln + 1;InsBufLine(hbuf,ln,"Log  :")
	ln = ln + 1;InsBufLine(hbuf,ln,"author | time | desc")
	ln = ln + 1;InsBufLine(hbuf,ln,"----- | ---- | ----")
	
	var time
	time = GetDate()
	var history
	history = GetUserName()
	history = Cat(history,"|")
	history = Cat(history,time)
	history = Cat(history,"|Created")
	ln = ln + 1;InsBufLine(hbuf,ln,history)

	ln = ln + 1;InsBufLine(hbuf,ln,"*/")

	free_func_inf(func_inf)

	SetBufIns(hbuf, func.lnFirst, 0)
	LoadSearchPattern("###", true, false, false);
	Search_Forward
}
