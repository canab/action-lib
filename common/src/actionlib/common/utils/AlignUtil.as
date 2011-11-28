package actionlib.common.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class AlignUtil
	{
		static public const TOP:String = "top";
		static public const BOTTOM:String = "bottom";
		static public const CENTER:String = "center";
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		static public const NONE:String = "none";
		
		public static function align(target:DisplayObject, bounds:Rectangle, horizontal:String, vertical:String):void
		{
			var objectBounds:Rectangle = target.getBounds(target.parent);
			var x:Number = objectBounds.x;
			var y:Number = objectBounds.y;
			
			if (horizontal == LEFT)
				x = bounds.left;
			else if (horizontal == CENTER)
				x = 0.5 * (bounds.left + bounds.right - objectBounds.width);
			else if (horizontal == RIGHT)
				x = bounds.right - objectBounds.width;
				
			if (vertical == TOP)
				y = bounds.top;
			else if (vertical == CENTER)
				y = 0.5 * (bounds.top + bounds.bottom - objectBounds.height);
			else if (vertical == BOTTOM)
				y = bounds.bottom - objectBounds.height;
				
			target.x += x - objectBounds.left;
			target.y += y - objectBounds.top;
		}
		
		public static function alignCenter(target:DisplayObject, bounds:Rectangle):void
		{
			align(target, bounds, CENTER, CENTER);
		}		
		
	}

}