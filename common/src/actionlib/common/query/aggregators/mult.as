package actionlib.common.query.aggregators
{
	public function mult(result:*, value:Number):Number
	{
		return (result === undefined) ? value : Number(result) * value;
	}
}
