
macro GetOrganization()
{
	var info;
	info = GetProgramEnvironmentInfo ()
	return info.UserOrganization;
}
macro GetUserName()
{
	var info;
	info = GetProgramEnvironmentInfo ()
	return info.UserName;
}
macro GetCurSiArg()
{
	var siarg
	siarg.hwnd = GetCurrentWnd()
	siarg.hbuf = GetCurrentBuf ()
	if ( hnil != hwnd )
	{
		siarg.sel = GetWndSel (siarg.hwnd)
	}
	else
	{
	  var sel
	  sel.fExtended = FALSE
	  siarg.sel = sel
	}
	return siarg
}

// given a file name, return the handle of this file.
// if this file not in project, return hnil.
// if the file not opened currently, this file will be opened.
// TO DO // deploy a faster algorithm to search the specified file. e.g. binary search
macro GetFileHandle(filename)
{
	var cnt;
	var i;
	var hbuf;
	var tbufname;
	var pos;
	var hprj;
	var fullpathmode;
	var prjdir;

	if ( -1 != FindStrR(filename,"\\") )
	{
		fullpathmode = 1
	}
	else
	{
		fullpathmode = 0
	}
	
	filename = tolower (filename)
	hprj = GetCurrentProj ()
	prjdir = GetProjDir (hprj);
	prjdir = cat(prjdir,"\\");
	
	if ( !hprj )
	{
		return hnil;
	}

	cnt = GetProjFileCount (hprj);
	i = 0
	while(i < cnt)
	{
		tbufname = GetProjFileName (hprj, i);

		if ( !fullpathmode )
		{
			tbufname = GetFileNameFromFullPath(tbufname)
		}
		else
		{
			tbufname = cat(prjdir,tbufname)
		}

		tbufname  = tolower (tbufname );
		if ( tbufname == filename )
		{
			tbufname = GetProjFileName (hprj, i);
			hbuf = OpenBuf(tbufname)
			return hbuf;
		}
		i = i+1;
	}
	return hnil;
}

macro GetCurFileType()
{
	hbuf = GetCurrentBuf()
	name = GetBufName (hbuf)
	extname = GetExtNameFromFileName(name)
	if ( "py" == extname )
	{
		return "python";
	}
	else
	{
		return "unknow";
	}
}

