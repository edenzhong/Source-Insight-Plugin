macro func_ins_preconfig_content()
{
	_ins_preconfig_content(0)
}
macro _ins_preconfig_content(flag)
{
	var key
	var ch
	if ( 0 == flag )
	{
		key = getkey()
		ch = CharFromKey(key)
	}
	else
	{
		ch = flag
	}

	var hbuf
	hbuf = GetCurrentBuf()

	
	// first line
	// to do
	if ( "t" == ch )
	{
		InsToDo()
	}
	// template <typename T>
	else if ( "T" == ch )
	{
		InsTemplate()
	}
	// insert multi line comment
	else if ( "p" == ch )
	{
		InsMulCmt()
	}
	// second line

	// third line
	// void
	else if ( "v" == ch )
	{
		void()
	}
	// insert "null"
	else if ( "n" == ch )
	{
		Null()
	}
	// macro
	else if ( "m" == ch )
	{
		SetBufSelText (hbuf, "macro ")
	}
	else
	{
		// show help
		var helpmsg
		helpmsg = "t : to do"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"T : template <typename T>")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"p : multi line comment")
		msg(helpmsg)
		
		helpmsg = "v : void"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"n : null")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"m : macro")
		msg(helpmsg)
	}
}
