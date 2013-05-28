
macro func_ins_cur_file_name()
{
	var hbuf
	var FileName
	var idx
	
	hbuf = GetCurrentBuf()
	FileName = GetBufName (hbuf)
	FileName = GetFileNameFromFullPath(FileName)
	idx = FindStr(FileName,".")
	if ( idx > 0 )
	{
		FileName = strmid(FileName,0,idx)
		SetBufSelText(hbuf, FileName)
	}
}

macro func_copy_cur_file_name()
{
	var hbuf
	var FileName
	var idx
	
	hbuf = GetCurrentBuf()
	FileName = GetBufName (hbuf)
	FileName = GetFileNameFromFullPath(FileName)
	idx = FindStr(FileName,".")
	if ( idx > 0 )
	{
		FileName = strmid(FileName,0,idx)

		var hbufClip
		hbufClip = GetBufHandle("Clipboard")
		ClearBuf (hbufClip)
		AppendBufLine(hbufClip, FileName)
	}
}

