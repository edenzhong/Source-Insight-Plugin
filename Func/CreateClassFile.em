macro CreateClassFile()
{
  var className;
  className = ask("Please input class name:");

  var srcFileName
  srcFileName = cat(className,".cpp")
  var srcFileHdl
  srcFileHdl = NewBuf(srcFileName)
  SetCurrentBuf (srcFileHdl)
  PutEnv("sepcialReq","")
  ins_file_header()


  var headFileName
  headFileName = cat(className,".h")
  var headFileHdl
  headFileHdl = NewBuf(headFileName)
  SetCurrentBuf (headFileHdl)
  PutEnv("sepcialReq","|fix hpp|")
  ins_file_header()
}

