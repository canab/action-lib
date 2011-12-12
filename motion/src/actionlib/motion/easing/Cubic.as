package actionlib.motion.easing
{
	final public class Cubic
	{
		public static function easeIn(k:Number):Number
		{
			return k * k * k;
		}

		public static function easeOut(k:Number):Number
		{
			return --k * k * k + 1;
		}

		public static function easeInOut(k:Number):Number
		{
			return (k *= 2) < 1
					? 0.5 * k * k * k
					: 0.5 * ((k -= 2) * k * k + 2);
		}
	}

}