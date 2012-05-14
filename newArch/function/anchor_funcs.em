
macro anchor_name()
{
  return "anchor"
}
macro func_set_anchor()
{
  var hwnd
  hwnd = GetCurrentWnd()
  if ( !hwnd )
  {
    return ;
  }
  var sel
  sel = GetWndSel (hwnd)
  
  var hbuf
  hbuf = GetWndBuf (hwnd)
  var filename
  filename = GetBufName (hbuf)

  var anchor
  anchor = anchor_name()
  
  BookmarksDelete(anchor)
  BookmarksAdd (anchor, filename, sel.lnfirst, sel.ichfirst)
}

macro func_retrieve_anchor()
{
  var anchor
  anchor = anchor_name();
  var mark
  mark = BookmarksLookupName(anchor)
  if ( nil == mark )
  {
    return ;
  }
  var hbuf
  hbuf = OpenBuf (mark.file)
  if ( !hbuf )
  {
    return ;
  }
  SetCurrentBuf (hbuf)
  SetBufIns (hbuf, mark.ln, mark.ich)
}
