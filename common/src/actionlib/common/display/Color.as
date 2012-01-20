package actionlib.common.display
{
	public class Color
	{
		public var r:int = 0;
		public var g:int = 0;
		public var b:int = 0;

		public function Color(color:int = 0)
		{
			value = color;
		}

		public function get value():int
		{
			return r << 16 | g << 8 | b;
		}

		public function set value(color:int):void
		{
			r = color >> 16;
			g = color >> 8 & 0x0000FF;
			b = color & 0x0000FF;
		}

		public function mult(multiplier:Number):Color
		{
			r *= multiplier;
			g *= multiplier;
			b *= multiplier;

			return this;
		}

		public function add(color:Color):Color
		{
			r += color.r;
			g += color.g;
			b += color.b;

			return this;
		}
	}
}
