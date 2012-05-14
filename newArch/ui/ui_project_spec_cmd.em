macro ui_project_spec_cmd()
{
	if ( is_custom_cmd_exist("project_spec_cmd") )
	{
		_custom_project_spec_cmd()
	}
	// this is a project specified cmd. no default behaviour.
}

