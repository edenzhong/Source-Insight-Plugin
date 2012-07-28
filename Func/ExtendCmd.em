macro ExtendCmd()
{
	var key
	var ch
	key = getkey()
	ch = CharFromKey(key)

	// prefix
	if ( "q" == ch )
	{
		InsPrefix()
	}
	// del prefix
	else if ("Q" == ch )
	{
		ClrPrefix()
	}
	
	// suffix
	else if ("w" == ch )
	{
		InsSuffix()
	}
	
	// del suffix
	else if ("W" == ch )
	{
		ClrSuffix()
	}

	else if ( "e" == ch )
	{
		Extern()
	}
	
	//else if ( "E" == ch )
	//{
		
	//}

	// get col
	else if ( "r" == ch )
	{
		GetCol()
	}
	// insert "return ture or false"
	else if ( "R" == ch )
	{
		ReturnTrueOrFalse()
	}
	// 
	//else if ( "t" == ch )
	//{
		
	//}
	// generate unit test class
	else if ( "T" == ch )
	{
		ui_gen_class_unit_test()
	}
	// switch windows between c & h file
	else if ( "y" == ch )
	{
		SwWnd()
	}
	//else if ( "Y" == ch )
	//{
		
	//}
	// var list
	else if ( "u" == ch )
	{
		VarList()
	}
	// func list
	else if ( "U" == ch )
	{
		FuncList()
	}
	// func header
	else if ( "i" == ch )
	{
		InsertHeader()
	}
	// file header
	else if ( "I" == ch )
	{
		ins_file_header()
	}
	//else if ( "o" == ch )
	//{
		
	//}
	//else if ( "O" == ch )
	//{
		
	//}
	
	//else if ( "P" == ch )
	//{
		
	//}
	
	///////////////////////////////////////////////////////
	//	the second line
	///////////////////////////////////////////////////////
	// generate access source code of a member variable
	else if ( "a" == ch )
	{
	  GenAccMethodOfMemVar()
	}
	else if ( "A" == ch )
	{
	  GenMethodBody()
	}
	// insert current file name
	else if ( "f" == ch )
	{
	  InsCurFileName()
	}
	
	///////////////////////////////////////////////////////
	//	the thrid line
	///////////////////////////////////////////////////////
	// expand class definition
	else if ( "c" == ch )
	{
		CreateClassFile()
	}
	// create new class and file
	else if ( "C" == ch )
	{
		ExpandClass()
	}
	

	///////////////////////////////////////////////////////
	//	the special sign
	///////////////////////////////////////////////////////
	// word to case
	else if ( "\\" == ch )
	{
		WordToCase()
	}
	// indent selection
	else if ( "	" == ch )
	{
		indent_selection()
	}
	



	
	// show help
	else
	{
		var helpmsg
		// first line
		helpmsg = "q : add prefix"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"Q : del prefix")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"w : add suffix")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"W : del suffix")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"e : insert \"extern\"")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"r : get col")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"R : insert return ture or false")
		helpmsg = cat(helpmsg,chEnter())
		//helpmsg = cat(helpmsg,"t : insert to do")
		//helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"T : generate unit test class")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"y : switch windows between c & h file")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"u : var list")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"U : func list")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"i : func header")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"I : file header")
		//helpmsg = cat(helpmsg,chEnter())
		//helpmsg = cat(helpmsg,"p : insert multi line comment")

		msg(helpmsg)

		// second line
		helpmsg = "a: generate access method of member variables"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"A: generate method body")
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"f: insert current file name")
		
		msg(helpmsg)

		// third line
		helpmsg = "c : create new class and file"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"C : expand class definition")
		helpmsg = cat(helpmsg,chEnter())
		
		msg(helpmsg)

		// special char
		helpmsg = "\\ : word to case"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"<tab> : indent selection")
		helpmsg = cat(helpmsg,chEnter())
		
		msg(helpmsg)
	}
	
}

