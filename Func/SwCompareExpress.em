
macro SwCompareExpress()
{
	hbuf = GetCurrentBuf ()
	text = GetBufSelText (hbuf)

	i = 0
	len = strlen(text)
	while(i<len)
	{
		if ( "=" == text[i] )
		{
			left = strmid(text,0,i)
			
			if ( "=" == text[i+1] )
			{
				right = strmid(text,i+2,len)
			}
			else
			{
				right = strmid(text,i+1,len)
			}
			
			text = cat(right," == ")
			text = cat(text,left)

			hbufClip = GetBufHandle("Clipboard")
			EmptyBuf(hbufclip)
			AppendBufLine(hbufClip, text)
			stop
		}

		if ( "!" == text[i] )
		{
			left = strmid(text,0,i)
			
			if ( "=" == text[i+1] )
			{
				right = strmid(text,i+2,len)
				text = cat(right," == ")
				text = cat(text,left)

				hbufClip = GetBufHandle("Clipboard")
				EmptyBuf(hbufclip)
				AppendBufLine(hbufClip, text)
				stop
			}
		}
		i = i + 1
	}
}

