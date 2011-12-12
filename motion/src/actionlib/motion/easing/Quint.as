package actionlib.motion.easing
{
	final public class Quint
	{
		public static function easeIn(k:Number):Number
		{
			return k * k * k * k * k;
		}

		public static function easeOut(k:Number):Number
		{
			return (k = k - 1) * k * k * k * k + 1;
		}

		public static function easeInOut(k:Number):Number
		{
			return (k *= 2) < 1
					? 0.5 * k * k * k * k * k
					: 0.5 * ((k -= 2) * k * k * k * k + 2);
		}
	}

}