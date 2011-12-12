package actionlib.common.utils
{
	public class ColorUtil
	{
		public static function fromRGB(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}

		public static function toRGB(color:uint):Object
		{
			return { r: color >> 16, g: color >> 8 & 0x0000FF, b: color & 0x0000FF };
		}

		public static function multColor(color:uint, multiplier:Number):uint
		{
			var rgb:Object = toRGB(color);
			return fromRGB(rgb.r * multiplier, rgb.g * multiplier, rgb.b * multiplier);
		}

		public static function addColor(color:uint, value:int):uint
		{
			var rgb:Object = toRGB(color);
			return fromRGB(rgb.r + value, rgb.g * value, rgb.b * value);
		}
	}
}