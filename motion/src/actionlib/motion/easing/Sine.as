package actionlib.motion.easing
{
	final public class Sine
	{
		static public function easeIn(k:Number):Number
		{
			return 1 - Math.cos(k * (Math.PI / 2));
		}

		static public function easeOut(k:Number):Number
		{
			return Math.sin(k * (Math.PI / 2));
		}

		static public function easeInOut(k:Number):Number
		{
			return - (Math.cos(Math.PI * k) - 1) / 2;
		}
	}
}
