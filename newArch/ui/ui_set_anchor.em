macro ui_set_anchor()
{
  if ( is_custom_cmd_exist("set_anchor") )
  {
  	_custom_set_anchor()
  }
  else
  {
  	func_set_anchor()
  }
}
macro ui_retrieve_anchor()
{
  if ( is_custom_cmd_exist("retrieve_anchor") )
  {
  	_custom_retrieve_anchor()
  }
  else
  {
  	func_retrieve_anchor()
  }
}

