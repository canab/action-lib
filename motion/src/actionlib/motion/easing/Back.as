package actionlib.motion.easing
{
	public class Back
	{
		static public var easeIn:Function = easeInWith();
		static public var easeOut:Function = easeOutWith();
		static public var easeInOut:Function = easeInOutWith();

		static public function easeInWith(s:Number = 1.70158):Function
		{
			return function (k:Number):Number
			{
				return k * k * ((s + 1) * k - s);
			}
		}

		static public function easeOutWith(s:Number = 1.70158):Function
		{
			return function (k:Number):Number
			{
				return (k = k - 1) * k * ((s + 1) * k + s) + 1;
			}
		}

		static public function easeInOutWith(s:Number = 1.70158):Function
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