macro ins_file_header()
{
  if ( is_custom_cmd_exist("ins_file_header") )
  {
  	_custom_ins_file_header()
  }
  else
  {
  	func_ins_file_header()
  }
}
