package actionlib.common.display
{
	import actionlib.common.utils.ColorUtil;

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorTransformUtil
	{
		static public function addColor(target:DisplayObject, color:int):void
		{
			var rgb:Object = ColorUtil.toRGB(color);
			var transform:ColorTransform = target.transform.colorTransform;
			transform.redOffset += rgb.r;
			transform.greenOffset += rgb.g;
			transform.blueOffset += rgb.b;
			target.transform.colorTransform = transform;
		}
	}
}
