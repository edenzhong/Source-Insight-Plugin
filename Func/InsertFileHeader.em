macro InsertFileHeader()
{
	InsFileHeader("")
}
macro GetFileType(fileName)
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
macro InsFileHeader(specialReq)
{
	ln = 0;
	var tmpstr;
	var hbuf
	hbuf = GetCurrentBuf()
	
	/* get project name*/
	i = GetCurrentProj ()
	i = GetProjName (i)
	PrjName = GetFileNameFromFullPath(i)
	PrjName = Cat("Project Name : ",PrjName)

	/* get file name */
	var FileName
	FileName = GetBufName (hbuf)
	FileName = GetFileNameFromFullPath(FileName)

	var pureFileName
	lim = FindStrR(FileName,".")
	if ( lim >= 0)
	{
		pureFileName = strmid(FileName,0,lim);
	}
	else
	{
		pureFileName = FileName;
	}
	if ( FindStr(specialReq,"|unit test class|") >= 0 )
	{
		var baseClassName
		baseClassName = strmid(pureFileName,5,strlen(pureFileName));
	}

	var FileNameLen
	FileNameLen = strlen(FileName)
	
	var FileNameDesc
	FileNameDesc = Cat("File Name    : ",FileName)

	/* get file type */
	var FileType
	if ( FindStr(specialReq,"|fix hpp|") >= 0 )
	{
		FileType = ".hpp"
	}
	else
	{
		FileType = GetFileType(FileName)
	}
	
	/* set description */
	var desc;
	desc = "Description  : ";
	if ( ".h" == FileType )
	{
		desc = Cat(desc,"Some declarations and definitions of ");
		desc = Cat(desc,pureFileName);
		desc = cat(desc,".c")
	}
	else if ( ".hpp" == FileType)
	{
		desc = Cat(desc,"Declarations of class ");
		desc = Cat(desc,pureFileName);
	}
	else if (".cpp" == FileType)
	{
		desc = Cat(desc,"Implementation of class ");
		desc = Cat(desc,pureFileName);
	}
	

	/* get data*/
	var history
	time = GetDate()
	history = GetUserName()
	history = cat(history,"	")
	history = Cat(history,time)
	history = Cat(history,"  	Created")
	

	var org
	org = GetOrganization()
	orglen = strlen(org)
	padlen = (78 - orglen)/2
	pad = ""
	while(padlen>0)
	{
		pad = cat(pad,"*")
		padlen = padlen - 1
	}
	cmthead = cat("/"pad)
	cmthead = cat(cmthead," ")
	cmthead = cat(cmthead,org)
	cmthead = cat(cmthead," ")
	cmthead = cat(cmthead,pad)
	InsBufLine(hbuf, ln, cmthead)
	//InsBufLine(hbuf, ln, "/**********Schneider Electric Buildings Business Shen Zhen R&D************")
	ln = ln + 1;
	InsBufLine(hbuf,ln,"")
	ln = ln + 1;
	copyright = cat("Copyright (c)   ",org)
	copyright = cat(copyright,". All rights reserved")

	InsBufLine(hbuf,ln,copyright);
	ln = ln + 1;
	InsBufLine(hbuf,ln,"")
	ln = ln + 1;
	InsBufLine(hbuf,ln,PrjName)
	ln = ln + 1
	InsBufLine(hbuf,ln,FileNameDesc)
	ln = ln + 1;
	lnbak = ln;
	InsBufLine(hbuf,ln,desc)
	ln = ln + 1;
	InsBufLine(hbuf,ln,"               ")
	ln = ln + 1;
	InsBufLine(hbuf,ln,"History:")
	ln = ln + 1;
	InsBufLine(hbuf,ln,"<author>		<time>		<desc>")
	ln = ln + 1;
	InsBufLine(hbuf, ln, history)
	ln = ln + 1;
	InsBufLine(hbuf,ln,"")
	ln = ln + 1;
	InsBufLine(hbuf, ln, "*******************************************************************************/")
	ln = ln + 1

	//add some header file information. such as #ifndef xxx, definition, etc.
	if( ".h" == FileType )	//h file of c
	{
		//FileName = toupper(FileName);
		len = strlen(FileName);
		len = len -2;
		FileName[len] = "_"
		FileName = Cat("_",FileName);
		//FileName = Cat(FileName,"_");
		FileNameDesc = Cat("#ifndef tac_nsp_ZigbeePlugin",FileName);
		InsBufLine(hbuf, ln,FileNameDesc);
		ln = ln + 1;
		FileNameDesc = Cat("#define tac_nsp_ZigbeePlugin",FileName);
		InsBufLine(hbuf, ln,FileNameDesc);
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	definitions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	include files");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	structure");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	extern variables");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	extern functions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"#endif");
		SetBufIns(hbuf, lnbak, 15);
		Select_To_End_Of_Line
	}
	else if( ".c" == FileType )	//c file
	{
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	definitions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	include files");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	structure");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	global variables");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	functions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		SetBufIns(hbuf, lnbak, 0);
		end_of_line
	}
	else if ( ".cpp" == FileType )	//cpp file
	{
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	include files");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");

		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			ln = ln + 1
			InsBufLine(hbuf, ln,"#include \"nsp/StdAfx.h\"");
			ln = ln + 1
			InsBufLine(hbuf, ln,"#include \"nsp/NspLoggerManager.h\"");
			ln = ln + 1
			InsBufLine(hbuf, ln,"#include \"nsp/SystemTypes.h\"");
			ln = ln + 1
			InsBufLine(hbuf, ln,"#include \"cppunit/extensions/HelperMacros.h\"");
			ln = ln + 1
			InsBufLine(hbuf, ln,"#include \"cppunit/Portability.h\"");
		}
		
		inFileName = GetBufName (hbuf)
		inFileName = GetFileNameFromFullPath(inFileName)
		pos = FindStr(inFileName,".")
		inFileName = strmid(inFileName,0,pos)
		inFileName = cat(inFileName,".h")
		ln = ln + 1;
		InsBufLine(hbuf, ln,"#include \"nsp/@inFileName@\"");
		
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"using namespace tac::nsp;");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"using namespace tac::nsp::ZigbeePlugin;");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	definitions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");

		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			ln = ln + 1;
			InsBufLine(hbuf, ln,"CPPUNIT_TEST_SUITE_REGISTRATION( @pureFileName@ );");
		}
		
		
		
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	structure");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	class implementation");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");

		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			ln = ln + 1
			InsBufLine(hbuf, ln,"void @pureFileName@::setUp()");
			ln = ln + 1
			InsBufLine(hbuf, ln,"{");
			plusIndent = IndentSign();
			ln = ln + 1
			InsBufLine(hbuf, ln,"@plusIndent@ZigbeePlugin::@baseClassName@ *ptr = new ZigbeePlugin::@baseClassName@();");
			ln = ln + 1
			InsBufLine(hbuf, ln,"@plusIndent@m_@baseClassName@.reset(ptr);");
			ln = ln + 1
			InsBufLine(hbuf, ln,"}");
			ln = ln + 1
			InsBufLine(hbuf, ln,"void @pureFileName@::tearDown()");
			ln = ln + 1
			InsBufLine(hbuf, ln,"{");
			plusIndent = IndentSign();
			ln = ln + 1
			InsBufLine(hbuf, ln,"@plusIndent@delete m_@baseClassName@.release();");
			ln = ln + 1
			InsBufLine(hbuf, ln,"}");

			ln = ln + 1
			InsBufLine(hbuf, ln,"void @pureFileName@::testBasicUsage()");
			ln = ln + 1
			InsBufLine(hbuf, ln,"{");
			plusIndent = IndentSign();
			ln = ln + 1
			InsBufLine(hbuf, ln,plusIndent);
			ln = ln + 1
			InsBufLine(hbuf, ln,"}");
		}
		
		
		
		//SetBufIns(hbuf, lnbak, 0);
		//end_of_line
		SetBufIns(hbuf, lnbak, 15);
		Select_To_End_Of_Line
	}
	else if ( ".hpp" == FileType ) //h file of cpp
	{
		//FileName = toupper(FileName);
		len = strlen(FileName);
		len = len -2;
		FileName[len] = "_"
		FileName = Cat("_",FileName);
		//FileName = Cat(FileName,"_");
		FileNameDesc = Cat("#ifndef tac_nsp_ZigbeePlugin",FileName);
		InsBufLine(hbuf, ln,FileNameDesc);
		ln = ln + 1;
		FileNameDesc = Cat("#define tac_nsp_ZigbeePlugin",FileName);
		InsBufLine(hbuf, ln,FileNameDesc);
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	include files");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			ln = ln + 1;
			InsBufLine(hbuf, ln,"#include <cppunit/extensions/HelperMacros.h>");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"#include \"nsp/@baseClassName@.h\"");
		}
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"namespace tac{namespace nsp{namespace ZigbeePlugin {");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	definitions");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"/**********************************************************");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"*	class declaration");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"**********************************************************/");

		ln = ln + 1;
		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			InsBufLine(hbuf, ln,"class @pureFileName@ : public CPPUNIT_NS::TestFixture");
		}
		else
		{
			InsBufLine(hbuf, ln,"class @pureFileName@");
		}

		plusIndent = IndentSign();
		ln = ln + 1;
		InsBufLine(hbuf, ln,"{");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"@plusIndent@public:");
		ln = ln + 1;
		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@virtual void setUp();");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@virtual void tearDown();");
		}
		else
		{
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@@pureFileName@();");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@virtual ~@pureFileName@();");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@###");
		}
		
		ln = ln + 1;
		InsBufLine(hbuf, ln,"@plusIndent@private:");
		if ( FindStr(specialReq,"|unit test class|") >= 0 )
		{
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@CPPUNIT_TEST_SUITE( @pureFileName@ );");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@CPPUNIT_TEST( testBasicUsage );");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@CPPUNIT_TEST_SUITE_END();");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@void testBasicUsage();");
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@std::auto_ptr<tac::nsp::ZigbeePlugin::@baseClassName@> m_@baseClassName@;");
		}
		else
		{
			ln = ln + 1;
			InsBufLine(hbuf, ln,"@plusIndent@@plusIndent@###");
		}
		ln = ln + 1;
		InsBufLine(hbuf, ln,"};");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"}}}");
		ln = ln + 1;
		InsBufLine(hbuf, ln,"#endif");
		SetBufIns(hbuf, lnbak, 15);
		Select_To_End_Of_Line
		LoadSearchPattern("###", true, false, false);
	}
	else
	{
		SetBufIns(hbuf, lnbak, 0);
		end_of_line
	}
}

