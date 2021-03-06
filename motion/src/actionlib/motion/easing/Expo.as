﻿package actionlib.motion.easing
{
	final public class Expo
	{
		public static function easeIn(k:Number):Number
		{
			return k == 0
					? 0
					: Math.pow(2, 10 * (k - 1));
		}

		public static function easeOut(k:Number):Number
		{
			return k == 1
					? 1
					: -Math.pow(2, -10 * k) + 1;
		}

		public static function easeInOut(k:Number):Number
		{
			if (k == 0)
				return 0;

			if (k == 1)
				return 1;

			return (k *= 2) < 1
					? 0.5 * Math.pow(2, 10 * (k - 1))
					: 0.5 * (-Math.pow(2, -10 * (k - 1)) + 2);
		}
	}

}