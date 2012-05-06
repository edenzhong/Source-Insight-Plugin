macro ui_auto_curly_brace()
{
  if ( is_custom_cmd_exist("auto_curly_brace") )
  {
  	_custom_auto_curly_brace()
  }
  else
  {
  	func_auto_curly_brace()
  }
}
