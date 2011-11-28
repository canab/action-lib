package actionlib.common.query.aggregators
{
	public function sum(result:*, value:Number):Number
	{
		return (result === undefined) ? value : Number(result) + value;
	}
}
