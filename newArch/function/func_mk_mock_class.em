macro func_mk_mock_class()
{
	// get the current class
	var cur_symb
	cur_symb = GetCurSymbol()
	if("" == cur_symb)
	{
		Msg("No symb selected!")
		return;
	}
	var sym_loca;
	sym_loca = GetSymbolLocation(cur_symb);

	if ( sym_loca.Type == "Class")
	{
		var mock_file
		mock_file = start_mock_buf(cur_symb)
		
		// enum all functions
		var hsyml
		var cchild
		var ichild
		var childsym

		var tmp

		hsyml = SymbolChildren(sym_loca)
		cchild = SymListCount(hsyml)
		ichild = 0
		while (ichild < cchild)
		{
			childsym = SymListItem(hsyml, ichild)

			var func_inf
			func_inf = get_func_info(childsym)
			if ( nil != func_inf)
			{
				var arg_cnt
				arg_cnt = get_arg_cnt(func_inf) 
				
				var mock_func
				// to do // check if it is "const" function
				mock_func = cat("  MOCK_METHOD",arg_cnt)
				mock_func = cat(mock_func,"(")
				mock_func = cat(mock_func,func_inf.name)
				mock_func = cat(mock_func,",")
				mock_func = cat(mock_func,func_inf.return_type)
				mock_func = cat(mock_func,"(")

				
				var arg_type
				var arg_name
				var arg_idx
				arg_idx = 0
				while( arg_idx < arg_cnt)
				{
					arg_type = getbufline(func_inf.arg_type_buf,arg_idx)
					arg_name = getbufline(func_inf.arg_name_buf,arg_idx)

					if ( arg_idx > 0 )
					{
						mock_func = cat(mock_func,",")
					}
					mock_func = cat(mock_func,arg_type)
					mock_func = cat(mock_func," ") 
					mock_func = cat(mock_func,arg_name) 
					arg_idx = arg_idx + 1
				}
				free_func_inf(func_inf)
				mock_func = cat(mock_func,"));")
				AppendBufLine(mock_file,mock_func)
			}
			
			ichild = ichild + 1
		}
		SymListFree(hsyml)
		finish_mock_buf(mock_file)
		setcurrentbuf(mock_file)
	}
}


macro start_mock_buf(class_name)
{
	var mock_buf
	mock_buf = newbuf(class_name # ".h")

	AppendBufLine(mock_buf,"#ifndef _Mock" # class_name # "_h_")
	AppendBufLine(mock_buf,"#define _Mock" # class_name # "_h_")
	AppendBufLine(mock_buf,"#include \"gmock/gmock.h\"")
	AppendBufLine(mock_buf,"#include \"" # class_name # ".h\"")

	AppendBufLine(mock_buf,"class Mock" # class_name # ":public " # class_name)
	AppendBufLine(mock_buf,"{")
	AppendBufLine(mock_buf,"public:")

	return mock_buf;
}

macro finish_mock_buf(mock_buf)
{
	AppendBufLine(mock_buf,"};")
	AppendBufLine(mock_buf,"#endif")
}
