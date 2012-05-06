macro func_ins_preconfig_content()
{
	var key
	var ch
	key = getkey()
	ch = CharFromKey(key)

	var hbuf
	hbuf = GetCurrentBuf()

	
	// first line
	// insert "to do"
	if ( "t" == ch )
	{
		InsToDo()
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
		helpmsg = cat(helpmsg,"p : multi line comment")
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
