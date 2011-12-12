package actionlib.motion.easing
{
	public class Back
	{
		public static var easeIn:Function = easeInWith();
		public static var easeOut:Function = easeOutWith();
		public static var easeInOut:Function = easeInOutWith();

		public static function easeInWith(s:Number = 1.70158):Function
		{
			return function (k:Number):Number
			{
				return k * k * ((s + 1) * k - s);
			}
		}

		public static function easeOutWith(s:Number = 1.70158):Function
		{
			return function (k:Number):Number
			{
				return (k = k - 1) * k * ((s + 1) * k + s) + 1;
			}
		}

		public static function easeInOutWith(s:Number = 1.70158):Function
		{
			s *= 1.525;

			return function (k:Number):Number
			{
				return (k *= 2) < 1
						? 0.5 * (k * k * ((s + 1) * k - s))
						: 0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2);
			}
		}
	}
}