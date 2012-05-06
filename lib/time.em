
macro GetDate()
{
	time = GetSysTime(0)
	value = time.year
	value = Cat(value,"-")
	value = Cat(value,time.month)
	value = Cat(value,"-")
	value = Cat(value,time.day)
	return value

}

macro GetDateTime()
{
	time = GetSysTime(0)
	ret = time.year
	value = Cat(value,"-")
	value = Cat(value,time.month)
	value = Cat(value,"-")
	value = Cat(value,time.day)
	value = cat(value," ")
	value = cat(value,time.Hour)
	value = cat(value,":")
	value = cat(value,time.Minute)
	value = cat(value,":")
	value = cat(value,time.Second)
}

