package actionlib.common.query.conditions
{
	public function typeIs(type:*):Function
	{
		return function(item:*):Boolean
		{
			return item is type;
		};
	}
}
