macro func_ins_file_header()
{
	var sepcialReq
	sepcialReq = GetEnv("sepcialReq")
	ins_file_header_body(sepcialReq)
	PutEnv("sepcialReq","")
}
macro ins_file_header_body(specialReq)
{
 	var hbuf
	hbuf = GetCurrentBuf()

	var str
	var endflag
	endflag = end_of_desc()
	var ln
	ln = 0
	while ( 1 )
	{
		str = file_header_desc(ln)
		if ( str != endflag )
		{
			InsBufLine(hbuf,ln,str);
		}
		else
		{
			break
		}
		ln = ln + 1
	}
	var arg
	arg = default_file_header_args()

	replaceinbuf(hbuf,"#Org#",arg.org,0,ln,true,false,0,0)
	replaceinbuf(hbuf,"#PrjName#",arg.prj,0,ln,true,false,0,0)
	replaceinbuf(hbuf,"#FileName#",arg.file,0,ln,true,false,0,0)
	//replaceinbuf(hbuf,"#FileDesc#",arg.desc,0,ln,true,false,0,0)
	replaceinbuf(hbuf,"#Author#",arg.author,0,ln,true,false,0,0)
	replaceinbuf(hbuf,"#Time#",arg.time,0,ln,true,false,0,0)

	file_type_proc(arg.file,ln,specialReq)
	LoadSearchPattern("###", true, false, false);
	Search_Forward
}
macro file_type_proc(file,start_ln,specialReq)
{
	var hbuf
	hbuf = GetCurrentBuf()

	var pos
	pos = FindStrR(file,".")
	var pure_file
	pure_file = strmid(file,0,pos)

	var tmp 
	
	var file_type
	if ( FindStr(specialReq,"|fix hpp|") >= 0 )
	{
		file_type = ".hpp"
	}
	else
	{
		file_type = get_file_type(file)
	}

	if ( ".h" == file_type )
	{
		tmp = cat(pure_file,".c")
		tmp = cat("Some declarations and definitions of ",tmp)
		replaceinbuf(hbuf,"#FileDesc#",tmp,0,start_ln,true,false,0,0)

		InsBufLine(hbuf, start_ln+0,"#ifndef _@pure_file@_h_");
		InsBufLine(hbuf, start_ln+1,"#define _@pure_file@_h_");
		InsBufLine(hbuf, start_ln+2,"###");
		InsBufLine(hbuf, start_ln+3,"#endif");
	}
	else if ( ".c" == file_type )
	{
		tmp = cat("Implementation of component ",pure_file)
		replaceinbuf(hbuf,"#FileDesc#",tmp,0,start_ln,true,false,0,0)
		InsBufLine(hbuf, start_ln,"#include \"@pure_file@.h\"");
	}
	else if ( ".hpp" == file_type )
	{
		tmp = cat("Declarations of class ",pure_file)
		replaceinbuf(hbuf,"#FileDesc#",tmp,0,start_ln,true,false,0,0)

		InsBufLine(hbuf, start_ln+0,"#ifndef _@pure_file@_h_");
		InsBufLine(hbuf, start_ln+1,"#define _@pure_file@_h_");
		
		var idt
		idt = IndentSign()
		InsBufLine(hbuf, start_ln+2,"class @pure_file@");
		InsBufLine(hbuf, start_ln+3,"{");
		InsBufLine(hbuf, start_ln+4,"public:");
		InsBufLine(hbuf, start_ln+5,"@idt@@pure_file@();");
		InsBufLine(hbuf, start_ln+6,"@idt@virtual ~@pure_file@();");
		InsBufLine(hbuf, start_ln+7,"@idt@###");
		InsBufLine(hbuf, start_ln+8,"private:");
		InsBufLine(hbuf, start_ln+9,"@idt@###");
		InsBufLine(hbuf, start_ln+10,"};");

		InsBufLine(hbuf, start_ln+11,"#endif");
		
	}
	else if ( ".cpp" == file_type )
	{
		tmp = cat("Implementation of class ",pure_file)
		replaceinbuf(hbuf,"#FileDesc#",tmp,0,start_ln,true,false,0,0)
		InsBufLine(hbuf, start_ln,"#include \"@pure_file@.h\"");
	}
	else
	{
		replaceinbuf(hbuf,"#FileDesc#","###",0,start_ln,true,false,0,0)
	}
}
macro get_file_type(fileName)
{
	var len
	len = strlen(fileName)
	if ( len > 2 )
	{
		var ex;
		ex=strmid(fileName,len - 2,len)
		if ( ".c" == ex )
		{
			return ex;
		}
		if ( ".h" == ex )
		{
			var tmp_src_fileName;
			tmp_src_fileName = strmid(fileName,0,len-1)
			tmp_src_fileName = cat(tmp_src_fileName,"cpp")

			var hbuf
			hbuf = OpenBuf(tmp_src_fileName);
			if ( hnil != hbuf)
			{
				return ".hpp";
			}
			return ".h";
		}
		if ( len > 4 )
		{
			ex = strmid(fileName,len - 4,len)
			if ( ".cpp" == ex )
			{
				return ex;
			}
			if ( ".hpp" == ex )
			{
				return ex;
			}
		}
	}
	return "";
}
macro default_file_header_args()
{
	var hbuf
	hbuf = GetCurrentBuf()
	
	var tmp
	var arg
	arg.org = GetOrganization()

	
	/* get project name*/
	tmp = GetCurrentProj ()
	tmp = GetProjName (tmp)
	arg.prj = GetFileNameFromFullPath(tmp)
	
	/* get file name */
	arg.file = GetFileNameFromFullPath(GetBufName (hbuf))
	
	arg.desc = "###"
	arg.author = GetUserName()
	arg.time = GetDate()
	arg.extend = nil

	return arg
}
macro end_of_desc()
{
	return "#end of desc#";
}
macro file_header_desc(ln)
{
 	if ( 0== ln ) return "/*************************************************************************"
 	if ( 1== ln ) return "Copyright (c)   #Org#. All rights reserved"
 	if ( 2== ln ) return ""
 	if ( 3== ln ) return "Project Name : #PrjName#"
 	if ( 4== ln ) return "File Name    : #FileName#"
 	if ( 5== ln ) return "Description  : #FileDesc#"
 	if ( 6== ln ) return "               "
 	if ( 7== ln ) return "History:"
 	if ( 8== ln ) return "<author>		<time>		<desc>"
	if ( 9== ln ) return "#Author#		#Time#  	Created"
	if (10== ln ) return "*************************************************************************/"
	return end_of_desc()
}