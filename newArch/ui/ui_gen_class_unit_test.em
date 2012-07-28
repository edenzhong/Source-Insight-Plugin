macro ui_gen_class_unit_test()
{
	if ( is_custom_cmd_exist("gen_class_unit_test") )
  {
  	_custom_gen_class_unit_test()
  }
  else
  {
  	func_gen_class_unit_test()
  }
}
