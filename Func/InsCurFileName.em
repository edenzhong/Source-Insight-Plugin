
macro InsCurFileName()
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


