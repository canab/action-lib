package actionlib.motion.properties
{
	public interface ITweenProperty
	{
		function initialize(target:Object, endValue:Object):void

		function applyTween(relativeTime:Number):void;

		function applyComplete():void;
	}
}
