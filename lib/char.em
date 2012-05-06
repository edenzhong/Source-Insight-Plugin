macro IndentSign()
{
	var hbuf
	hbuf = GetCurrentBuf ()
	var file
	file = GetBufName (hbuf)
	var ext
	ext = GetExtNameFromFileName(file) 

	if (( "cpp" == ext ) || ("hpp" == ext)
		|| ("c" == ext) || ("h" == ext))
	{
		return "  ";
	}
	else
	{
		return "	"
	}
}
// return a "new line" string.
macro chEnter()
{
	var cr;
	var lf;
	var etr;
	cr = CharFromAscii (13)
	lf = CharFromAscii (10)
	etr = cat(cr,lf)
	return etr
}
macro isPunctuation(ch)
{
	if ( islower(ch) )
	{
		return 0
	}
	if ( IsNumber (ch) )
	{
		return 0
	}
	if ( isupper (ch) )
	{
		return 0
	}
	if ( "_" == ch )
	{
		return 0;
	}
	return 1;
}
macro isSpace(ch)
{
	if( " " == ch )
	{
		return 1
	}
	if( "	" == ch )
	{
		return 1
	}
	return 0
}

// distinguish what kind of the char.
// ret	0	: 	,
//		1	:	char, _
//		2	:	number
//		3	:	rubbish char
//		4	:	')'
//		5	:	';'
//		6	:	'('
//		7	:	space
//		8	:	tab
macro WhatChar(ch)
{
	if(islower (ch))
	{
		return 1;
	}
	if(isupper (ch))
	{
		return 1;
	}

	if(IsNumber (ch))
	{
		return 2;
	}
	
	if("," == ch)	//== ","
	{
		return 0;
	}

	if(")" == ch)	//==")"
	{
		return 4
	}

	if("_" == ch)	// == "_"
	{
		return 1;
	}

	if(";" == ch)	//==';'
	{
		return 5;
	}

	if("(" == ch)	//=='('
	{
		return 6;
	}

	if ( " " == ch ) // == space
	{
		return 7;
	}

	if ( "	" == ch ) // == tab
	{
		return 8;
	}

	return 3;	//other char.	
}

