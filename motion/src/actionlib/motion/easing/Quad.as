package actionlib.motion.easing
{
	final public class Quad
	{
		public static function easeIn(k:Number):Number
		{
			return k * k;
		}

		public static function easeOut(k:Number):Number
		{
			return -k * (k - 2);
		}

		public static function easeInOut(k:Number):Number
		{
			return (k *= 2) < 1
					? 0.5 * k * k
					: -0.5 * (--k * (k - 2) - 1);
		}
	}

}