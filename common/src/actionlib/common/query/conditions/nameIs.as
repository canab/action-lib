package actionlib.common.query.conditions
{
	public function nameIs(value:*):Function
	{
		return function(item:*):Boolean
		{
			return item
				&& item.hasOwnProperty("name")
				&& item.name == value;
		};
	}
}
