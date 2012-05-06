macro indent_selection()
{
	if ( is_custom_cmd_exist("indent_selection") )
	{
		_custom_indent_selection()
	}
	else
	{
		func_indent_selection()
	}
}
