// get information of a function or a method.
// input a symbol record
// return a func_inf record
// func_inf.type : the info type, could be "Function" or "Method" or "Method Prototype"
// func_inf.name : the leaf name of the function
// func_inf.return_type : the return type of the function, could be "void", "int", and so on.
// func_inf.arg_type_buf : a buf contain the argument type.
// func_inf.arg_name_buf : a buf contain the argument name.
macro get_func_info(symb)
{
	// get symb type.
	if ( FindStr(symb.Type,"Method") < 0 )
	{
		if ( FindStr(symb.Type,"Function") < 0 )
		{
			return nil;
		}
	}
	
	var  func_inf
	func_inf.type = symb.Type;

	var tmp
	var hbuf
	hbuf = openbuf(symb.File )
	if ( hnil == hbuf )
	{
		msg("Could not open the file which contains the symbol.")
		return nil
	}
	var ln
	ln = symb.lnFirst
	var symb_body
	while(ln < symb.lnLim )
	{
		tmp = GetBufLine (hbuf, ln)
		symb_body = cat(symb_body,tmp)
		ln = ln + 1
	}
	
	var elements
	elements = split_by_set(symb_body," 	(),;*&","(),;*&","elements")

	var ele_cnt
	ele_cnt = GetBufLineCount (elements)

	
	// get return type lim pos and arg start pos
	var arg_start_ln
	arg_start_ln = -1
	var return_type_lim_ln
	return_type_lim_ln = -1
	ln = 0
	while(ln < ele_cnt)
	{
		tmp = GetBufLine(elements,ln)
		if ( "(" == tmp )
		{
			arg_start_ln = ln + 1
			if ( ln > 1 )
			{
				return_type_lim_ln = ln -1
			}
			break
		}
		ln = ln + 1
	}
	if ( -1 == return_type_lim_ln )
	{
		msg("Not a valid function/method declare")
		
		free_split_buf(elements)
		return nil;
	}

	// get return type
	func_inf.return_type = ""
	ln = 0
	while(ln < return_type_lim_ln)
	{
		tmp = GetBufLine(elements,ln)
		if (( "virtual" == tmp ) || ("static" == tmp))
		{
			ln = ln + 1
			continue
		}
		
		func_inf.return_type = cat(func_inf.return_type,tmp)
		func_inf.return_type = cat(func_inf.return_type," ")

		ln = ln + 1
	}

	// get function name
	func_inf.name = SymbolLeafName(symb);

	// get args
	func_inf.arg_type_buf = newbuf(symb.symbol # ".arg_type")
	func_inf.arg_name_buf = newbuf(symb.symbol # ".arg_name")

	tmp = GetBufLine(elements,arg_start_ln)
	if ( "void" != tmp )
	{
		var arg_type
		var cache
		cache = ""
		arg_type = ""

		ln = arg_start_ln
		while(ln < ele_cnt)
		{
			tmp = GetBufLine(elements,ln)
			
			if (( "," == tmp ) || (")" == tmp))
			{
				AppendBufLine(func_inf.arg_type_buf,arg_type)
				AppendBufLine(func_inf.arg_name_buf,cache)

				cache = ""
				arg_type = ""
				if ( ")" == tmp )
				{
					break;
				}
			}
			else
			{
				arg_type = cat(arg_type,cache)
				arg_type = cat(arg_type," ")
				cache = tmp
			}
			ln = ln + 1
		}
	}

	// to do // check if the function is const
	
	free_split_buf(elements)
	return func_inf;
}
macro free_func_inf(func_inf)
{
	if ( nil == func_inf )
	{
		return ;
	}
	closebuf(func_inf.arg_type_buf)
	closebuf(func_inf.arg_name_buf)
}
macro get_arg_cnt(func_inf)
{
	if ( nil == func_inf )
	{
		return 0;
	}
	var cnt
	cnt = GetBufLineCount(func_inf.arg_type_buf)
	if ( 1 == cnt )
	{
		var tmp
		tmp = GetBufLine(func_inf.arg_type_buf,0)
		if ( strlen(tmp) < 1 )
		{
			return 0
		}
	}
	return cnt
}
