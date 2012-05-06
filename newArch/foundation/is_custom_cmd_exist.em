macro is_custom_cmd_exist(func)
{
  var custom_func
  custom_func = cat("_custom_",func)
  
  var file_name
  file_name = cat(custom_func,".em")
  var hbuf
  hbuf = openbuf(file_name)
  if ( hnil != hbuf )
  {
    closebuf(hbuf)
    return true;
  }
  else
  {
    return false;
  }
}
