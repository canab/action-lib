package actionlib.common.query.mappers
{
	public function name(item:Object):String
	{
		if (!item)
			return null;
		
		if (!item.hasOwnProperty("name"))
			return null;
		
		return item.name;
	}
}
