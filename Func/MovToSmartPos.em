

macro MovCursorToSmartBegin()
{
	var hbuf
	var ln
	var len
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)

	if ( len > 0 )
	{
		End_Of_Line
		Smart_Beginning_Of_Line
	}
}

macro MovCursorToSmartEnd()
{
	var hbuf
	var ln
	var len
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)

	if ( len > 0 )
	{
		Beginning_of_Line
		Smart_End_Of_Line
	}
}
