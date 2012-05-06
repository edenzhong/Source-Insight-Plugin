macro ui_ins_preconfig_content()
{
	if ( is_custom_cmd_exist("ins_preconfig_content") )
	{
		_custom_ins_preconfig_content()
	}
	else
	{
		func_ins_preconfig_content()
	}
}
