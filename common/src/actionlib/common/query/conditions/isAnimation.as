package actionlib.common.query.conditions
{
	import flash.display.MovieClip;

	public function isAnimation(value:*):Boolean
	{
		return (value is MovieClip) && MovieClip(value).totalFrames > 1;
	}
}
