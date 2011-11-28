package actionlib.common.query.conditions
{
	public function prefixIs(value:*):Function
	{
		return function(item:*):Boolean
		{
			return item
				&& item.hasOwnProperty("name")
				&& String(item.name).indexOf(value) == 0;
		};
	}
}
