package actionlib.common.utils
{
	public class ColorUtil
	{
		static public function fromRGB(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}

		static public function toRGB(color:uint):Object
		{
			return { r: color >> 16, g: color >> 8 & 0x0000FF, b: color & 0x0000FF };
		}

		static public function multColor(color:uint, multiplier:Number):uint
		{
			var rgb:Object = toRGB(color);
			return fromRGB(rgb.r * multiplier, rgb.g * multiplier, rgb.b * multiplier);
		}

		static public function addColor(color:uint, value:int):uint
		{
			var rgb:Object = toRGB(color);
			return fromRGB(rgb.r + value, rgb.g * value, rgb.b * value);
		}
	}
}