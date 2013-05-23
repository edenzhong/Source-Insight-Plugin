macro func_gen_class_unit_test()
{
	var cur_symb
	cur_symb = getcursymbol()
	var symb_loca
	symb_loca = GetSymbolLocation (cur_symb)
	if ( "Class" != symb_loca.type )
	{
		msg("Not a class")
		return ;
	}

	var test_class_name
	test_class_name = cat("test_",cur_symb)

	var src_file_name
	src_file_name = cat(test_class_name,".cpp")

	var src_handle
	src_handle = newbuf(src_file_name)
	setcurrentbuf(src_handle)

	gtest_unit_test(symb_loca)
}
macro gtest_unit_test(symb)
{
	var base_class_name
	base_class_name = SymbolLeafName (symb)

	var test_class_name
	test_class_name = cat("Test",base_class_name);
	
	var hbuf
	hbuf = getcurrentbuf()

	var base_class_name
	base_class_name = SymbolLeafName (symb)

	var test_class_name
	test_class_name = cat("Test",base_class_name);

	gtest_set_template(hbuf,symb,base_class_name,test_class_name)
	gtest_set_test_func(hbuf,symb,base_class_name,test_class_name)

}
macro gtest_set_template(hbuf,symb,base_class_name,test_class_name)
{
	AppendBufLine(hbuf,"#include <boost/pointer_cast.hpp>")
	AppendBufLine(hbuf,"")
	AppendBufLine(hbuf,"#include <gtest/gtest.h>")
	AppendBufLine(hbuf,"#include <gmock/gmock.h>")
	AppendBufLine(hbuf,"")
	AppendBufLine(hbuf,"#include \"" # base_class_name # ".h\"")
	AppendBufLine(hbuf,"using namespace ::testing;")
	AppendBufLine(hbuf,"")
	AppendBufLine(hbuf,"class " # test_class_name # ": public testing::Test  ")
	AppendBufLine(hbuf,"{")
	AppendBufLine(hbuf,"public:  ")
	AppendBufLine(hbuf,"  virtual void SetUp()")
	AppendBufLine(hbuf,"  {")
	AppendBufLine(hbuf,"    target_.reset(new " # base_class_name # ");")
	AppendBufLine(hbuf,"  }")
	AppendBufLine(hbuf,"  virtual void TearDown()")
	AppendBufLine(hbuf,"  {")
	AppendBufLine(hbuf,"    target_.reset();")
	AppendBufLine(hbuf,"  }")
	AppendBufLine(hbuf,"protected:")
	AppendBufLine(hbuf,"  boost::shared_ptr<" # base_class_name # "> target_;")
	AppendBufLine(hbuf,"};")
}
macro gtest_set_test_func(hbuf,symb,base_class_name,test_class_name)
{
	// enum all functions
	var hsyml
	var cchild
	var ichild
	var childsym

	var tmp

	hsyml = SymbolChildren(symb)
	cchild = SymListCount(hsyml)
	ichild = 0
	while (ichild < cchild)
	{
		childsym = SymListItem(hsyml, ichild)

		var func_inf
		func_inf = get_func_info(childsym)
		if ( nil != func_inf)
		{
			tmp = func_inf.name
			if ( "~" != tmp[0] )
			{
				AppendBufLine(hbuf,"TEST_F(" # test_class_name # "," # func_inf.name # ")")
				AppendBufLine(hbuf,"{")
				AppendBufLine(hbuf,"	//target_->" # func_inf.name # "();")
				AppendBufLine(hbuf,"}")
			}
			
			free_func_inf(func_inf)
		}
		ichild = ichild + 1
	}
	SymListFree(hsyml)
}
macro cppunit_unit_test()
{
	// get current word as the class name
	var hwnd
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
	{
		return
	}
	var hbuf
	hbuf = GetWndBuf(hwnd)

	Beginning_of_Selection
	Select_Word

	var sel
	sel = GetWndSel(hwnd)
	var className
	szLine = GetBufLine (hbuf, sel.lnfirst)
	className = strmid(szLine,sel.ichfirst,sel.ichlim)
	
	// make test class as Test{class name}
	var testClassName
	testClassName = cat("Test_",className);

	// generate cpp
	var srcFileName
	srcFileName = cat(testClassName,".cpp")
	var srcFileHdl
	srcFileHdl = NewBuf(srcFileName)
	SetCurrentBuf (srcFileHdl)
	PutEnv("sepcialReq","|unit test class|")
	ins_file_header()

/*  a unit test don't need a h file.
	var headFileName
	headFileName = cat(testClassName,".h")
	var headFileHdl
	headFileHdl = NewBuf(headFileName)
	SetCurrentBuf (headFileHdl)
	PutEnv("sepcialReq","|fix hpp|unit test class|")
	ins_file_header()
	*/
}
