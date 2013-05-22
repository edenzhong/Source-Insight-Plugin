macro ui_mk_mock_class()
{
	if ( is_custom_cmd_exist("mk_mock_class") )
  {
  	_custom_ui_mk_mock_class()
  }
  else
  {
  	func_mk_mock_class()
  }
}

