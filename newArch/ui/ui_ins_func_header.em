macro ui_ins_func_header()
{
  if ( is_custom_cmd_exist("ins_func_header") )
  {
  	_custom_ins_func_header()
  }
  else
  {
  	func_ins_func_header()
  }
}

