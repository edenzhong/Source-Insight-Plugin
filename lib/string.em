/*
这个模块用于处理所有跟字符串有关的操作
*/



// 把一个数字转换为对应的字符串
macro NumToStr(num)
{
	if( num > 0 )
	{
		var str;
		var tmp;
		var ch;
		str = "";
		while( num > 0 )
		{
			tmp = num / 10;
			tmp = tmp * 10;
			tmp = num - tmp;
			ch = CharFromAscii(48+tmp);
			str = cat(ch,str);
			num = num / 10
		}
		return str;
	}
	return "0"
}
macro NumToHexStr(num)
{
	num = StrToNum(num)
	if( num > 0 )
	{
		var str;
		var tmp;
		var ch;
		str = "";
		while( num > 0 )
		{
			tmp = num / 16;
			tmp = tmp * 16;
			tmp = num - tmp;
			if ( tmp < 10 )
			{
				ch = CharFromAscii(48+tmp);
			}
			else
			{
				ch = CharFromAscii(87+tmp);
			}
			str = cat(ch,str);
			num = num / 16
		}
		str = cat("0x",str)
		return str;
	}
	return "0x0"
}
// 从一个字符串提取十进制数字
macro StrToDec(str)
{
	var len
	len = strlen(str)
	var num
	num = 0
	var i
	i = 0
	while(i < len )
	{
		if ( IsNumber (str[i]) )
		{
			num = num * 10
			num = num + str[i]
			i = i + 1
		}
		else
		{
			break;
		}
		
	}
	return num
}
macro GetHexNum(ch)
{
	if ( strlen(ch) != 1 )
	{
		return -1;
	}
	if ( IsNumber(ch) )
	{
		return ch;
	}
	if ( ch == "a" || ch == "A" )
	{
		return 10;
	}
	if ( ch == "b" || ch == "B" )
	{
		return 11;
	}
	if ( ch == "c" || ch == "C" )
	{
		return 12;
	}
	if ( ch == "d" || ch == "D" )
	{
		return 13;
	}
	if ( ch == "e" || ch == "E" )
	{
		return 14;
	}
	if ( ch == "f" || ch == "F" )
	{
		return 15;
	}
	return -1;
}
// 从一个字符串提取十六进制数
macro StrToHex(str)
{
	var len
	len = strlen(str)
	var num
	var tmp
	num = 0
	var i
	i = 0
	while(i < len )
	{
		tmp = GetHexNum(str[i])
		if ( tmp >= 0 )
		{
			num = num * 16
			num = num + tmp
			i = i + 1
		}
		else
		{
			break;
		}
	}
	return num
}
// 从一个字符串提取数字，如果字符串以0x开头，则提取16进制，否则提取10进制
macro StrToNum(str)
{
	if ( strlen(str) > 2 )
	{
		if (( str[0] == "0" ) && (( str[1] == "x" ) || (str[1] == "X")))
		{
			return StrToHex(strmid(str,2,strlen(str)))
		}
	}
	return StrToDec(str);
}

macro ReverseStr(str)
{
	var len
	var retstr
	var idx
	
	len = strlen(str)
	retstr = ""
	idx = 0
	while(idx<len)
	{
		retstr=cat(str[idx],retstr)
		idx=idx+1
	}
	return retstr
}



// get the blank in front of a string
macro get_pre_space(str)
{
	idx = 0
	len = strlen(str)
	while(idx<len)
	{
		if ( str[idx] != " " )
		{
			if ( str[idx] != "	" )
			{
				break;
			}
		}
		idx = idx + 1
	}

	if ( idx > 0 )
	{
		pre_space = strmid(str,0,idx)
		return pre_space
	}
	else
	{
		return "";
	}
}

//given a string and the position, we will find a word from the pos
//and return the word next to the pos.
//flag : 0 : the 1st char must be a letter or '_'
//       1 : the 1st char may be a letter or number or '_'
macro GetWordInAString(text,pos,flag)
{
	len = strlen(text);
	if(pos >= len)
	{
		return nil;
	}

/*	while(WhatChar(text[pos]) != 1)	//find the 1st char
	{
		pos = pos + 1;
		if(pos >= len)
		{
			return nil;
		}
	}*/
	while(1)	//find the 1st char
	{
		if ( 0 == flag )
		{
			if ( WhatChar(text[pos]) == 1 )
			{
				break;
			}
		}
		else if ( 1 == flag )
		{
			if ( WhatChar(text[pos]) == 1 )
			{
				break;
			}
			if ( WhatChar(text[pos]) == 2 )
			{
				break;
			}
		}
		
		pos = pos + 1;
		if(pos >= len)
		{
			return nil;
		}
	}

	pos1 = pos;

	pos = pos + 1;
	while(pos < len)
	{
		ch = WhatChar(text[pos]);
		if(ch != 1)
		{
			if(ch != 2)
			{
				ret = nil
				ret.word = strmid(text,pos1,pos);
				ret.position = pos
				return ret
			}
		}
		pos = pos + 1
	}
	if(pos == pos1)
	{
		return nil;
	}

	ret = nil
	ret.word = strmid(text,pos1,pos);
	ret.position = pos
	return ret

}

macro GetWordInAStringByIdx(str,index)
{
	var gword
	gword = GetWordInfoInAStringByIdx(str,index)
	if ( gword != nil )
	{
		return gword.word;
	}
	else
	{
		return "";
	}
}

macro GetWordInfoInAStringByIdx(str,index)
{
	var gword
	gword.position = 0
	gword.word = ""
	if ( index < 1 )
	{
		return gword
	}
	pos = 0
	idx = 0
	while(idx<index)
	{
		pos = gword.position
		gword = GetWordInAString(str,pos,1)
		if ( gword == nil )
		{
			return nil
		}
		idx = idx + 1
	}
	return gword
}

//given a string and the position, we will find a word from the pos
//in reverse dir, and return the word before to the pos.
//flag : 0 : the 1st char must be a letter or '_'
//       1 : the 1st char may be a letter or number or '_'
macro GetWordInAStringR(text,pos,flag)
{
//	text = ReverseStr(text)
//	ret = GetWordInAString(text,pos,flag)

}
macro GetWordInfoInAStringByIdxR(str,index)
{
	var ret
	str = ReverseStr(str)
	ret = GetWordInfoInAStringByIdx(str,index)
	if ( ret != nil )
	{
		ret.word = ReverseStr(ret.word)
		var len
		len = strlen(str)
		ret.position = len - ret.position;

		var word
		word = ret.word
		var pos
		pos = ret.position
	}
	return ret
}

macro GetWordInAStringByIdxR(str,index)
{
	var ret
	str = ReverseStr(str)
	ret = GetWordInAStringByIdx(str,index)
	ret = ReverseStr(ret)
	return ret;
}




//get 1st line of str
//return a structure
//LnStr.str is the context of the 1st
//LnStr.pos is the offset of the next line
macro GetLineOfStr(text)
{
	pos = 0
	len = strlen(text)
	if ( len < 1)
	{
		return nil
	}
	var LnStr;
	while(pos < len)
	{
		ch = AsciiFromChar (text[pos])
		if ( 13 == ch ) // 0x0d
		{
			LnStr.str = strmid(text,0,pos)
			
			pos = pos + 1
			if ( pos < len )
			{
				ch = AsciiFromChar (text[pos])
				if ( 10 == ch ) //0x0a
				{
					pos = pos + 1
				}
			}
			
			LnStr.pos = pos
			tt = LnStr.str
			return LnStr
		}
		pos = pos + 1
	}
	LnStr.str = text
	LnStr.pos = len
	return LnStr
}

//find string 'strseg' from string 'strbase'
//if found, return the pos of strbase that strseg appear 1st time,
//or return -1 if not found
macro FindStr(strbase,strseg)
{
	var seglen;
	var baselen;
	var index;
	var str;
	
	seglen = strlen(strseg)
	baselen = strlen(strbase)

	index = 0
	while( baselen >=( index + seglen ) )
	{
		str = strmid(strbase,index,seglen+index)
		if ( str == strseg )
		{
			return index
		}

		index = index + 1;
	}
	return -1
}

//find string 'strseg' from string 'strbase' with backward direction.
//if found, return the pos of strbase that strseg appear 1st time,
//or return -1 if not found
macro FindStrR(strbase,strseg)
{
	var seglen;
	var baselen;
	var index;
	var str;
	
	seglen = strlen(strseg)
	baselen = strlen(strbase)

	if ( baselen < seglen )
	{
		return -1;
	}
	
	index = baselen - seglen;

	while ( index >= 0 )
	{
		str = strmid(strbase,index,seglen+index)
		if ( str == strseg )
		{
			return index
		}

		index = index - 1;
	}
	return -1;
}
macro GetFilePathFromFullPath(fullpath)
{
	var pos
	var filename
	
	pos = FindStrR(fullpath,"\\");
	if ( pos != -1 )
	{
		pos = pos + 1;
		filename = strmid(fullpath,0,pos);
	}
	else
	{
		filename = fullpath
	}
	
	return filename
}
// given a fullpath, return the pure file name.
macro GetFileNameFromFullPath(fullpath)
{
	var pos
	var filename
	
	pos = FindStrR(fullpath,"\\");
	if ( pos != -1 )
	{
		pos = pos + 1;
		filename = strmid(fullpath,pos,strlen(fullpath));
	}
	else
	{
		filename = fullpath
	}
	
	return filename
}
macro GetExtNameFromFileName(file)
{
	var pos

	pos = FindStrR(file,".")
	if (pos >= 0 )
	{
		var ext
		ext = strmid(file,pos+1,strlen(file));
		return ext;
	}
	return "";
}

// compare 2 strings. if str0 > str1 return a positive position of 
// the different char. if str0 < str1 return a negative position of
// the different char. if str0 == str1 return 0
// CAUTION : the position base on 1, not base on 0.
macro strcmp(str0,str1)
{
	var len0;
	var len1;
	len0 = strlen(str0)
	len1 = strlen(str1)

	var i;
	var cmpcnt;
	var s0
	var s1
	cmpcnt = min(len0,len1)
	i = 0
	while(i < cmpcnt )
	{
		s0 = AsciiFromChar (str0[i])
		s1 = AsciiFromChar (str1[i])
		if ( s0 > s1 )
		{
			return i+1;
		}
		if ( s0 < s1 )
		{
			return -(i+1);
		}
		i = i + 1;
	}
	if ( len0 == len1 )
	{
		return 0;
	}
	if ( len0 > len1 )
	{
		return len1 + 1
	}
	return -(len0 + 1)
}

//在str里找到第一个属于set的字符
macro FindOneOf(str,set)
{
	var idx
	var len_str
	var len_set
	idx = 0
	len_str = strlen(str)
	len_set = strlen(set)

	while ( idx < len_str )
	{
		if ( FindStr(set,str[idx]) >= 0 )
		{
			return idx
		}
		idx = idx + 1
	}
	return -1
}

// 在str里找到第一个不属于set的字符
macro FindNotOf(str,set)
{
	var idx
	var len_str
	var len_set
	idx = 0
	len_str = strlen(str)
	len_set = strlen(set)

	while ( idx < len_str )
	{
		if ( FindStr(set,str[idx]) < 0 )
		{
			return idx
		}
		idx = idx + 1
	}
	return -1
}
// clear the prefix and suffix space/tab
macro purge_string(str)
{
  var purge
  var start
  start = 0
  var len
  len = strlen(str)
  while ( start < len )
  {
    if ( str[start] == " " 
      || str[start] == "	")
    {
      start = start + 1
    }
    else
    {
      break
    }
  }

  var lim
  lim = len
  while(lim>0)
  {
    if ( str[lim-1] == " " 
      || str[lim-1] == "	")
    {
      lim = lim - 1
    }
    else
    {
      break
    }
  }
  if ( lim <= start )
  {
    purge = ""
  }
  else
  {
    purge = strmid(str,start,lim)
  }
  return purge;
}
