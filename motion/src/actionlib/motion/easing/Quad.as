package actionlib.motion.easing
{
	final public class Quad
	{
		static public function easeIn(k:Number):Number
		{
			return k * k;
		}

		static public function easeOut(k:Number):Number
		{
			return -k * (k - 2);
		}

		static public function easeInOut(k:Number):Number
		{
			return (k *= 2) < 1
					? 0.5 * k * k
					: -0.5 * (--k * (k - 2) - 1);
		}
	}

}