package actionlib.motion.easing
{
	final public class Sine
	{
		public static function easeIn(k:Number):Number
		{
			return 1 - Math.cos(k * (Math.PI / 2));
		}

		public static function easeOut(k:Number):Number
		{
			return Math.sin(k * (Math.PI / 2));
		}

		public static function easeInOut(k:Number):Number
		{
			return - (Math.cos(Math.PI * k) - 1) / 2;
		}
	}
}
