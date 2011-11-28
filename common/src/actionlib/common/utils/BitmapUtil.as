package actionlib.common.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapUtil
	{
		public static function replaceWithBitmap(content:DisplayObject, bounds:Rectangle = null, transparent:Boolean = true):Bitmap
		{
			var bitmap:Bitmap = convertToBitmapWithPosition(content, bounds, transparent);

			content.parent.addChildAt(bitmap, content.parent.getChildIndex(content));
			DisplayUtil.detachFromDisplay(content);

			return bitmap;
		}

		public static function convertToBitmapWithPosition(content:DisplayObject, bounds:Rectangle = null, transparent:Boolean = true):Bitmap
		{
			bounds = bounds || calculateIntBounds(content);

			var bitmap:Bitmap = BitmapUtil.convertToBitmap(content, bounds, transparent);

			var position:Point = DisplayUtil.transformCoords(bounds.topLeft, content, content.parent);
			bitmap.x = Math.floor(position.x);
			bitmap.y = Math.floor(position.y);

			return bitmap;
		}

		public static function convertToBitmap(content:DisplayObject, bounds:Rectangle = null, transparent:Boolean = true):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(getBitmapData(content, bounds, transparent));
			bitmap.smoothing = true;
			return bitmap;
		}

		public static function getBitmapData(content:DisplayObject, bounds:Rectangle = null, transparent:Boolean = true):BitmapData
		{
			bounds = bounds || calculateIntBounds(content);

			var matrix:Matrix = new Matrix();
			matrix.translate(-bounds.left, -bounds.top);

			var fillColor:int = transparent ? 0x00000000 : 0xFF0000;

			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, transparent, fillColor);
			bitmapData.draw(content, matrix, null, null, null, true);
			return bitmapData;
		}

		public static function calculateIntBounds(content:DisplayObject):Rectangle
		{
			var bounds:Rectangle = content.getBounds(content);
			bounds.left = Math.floor(bounds.left);
			bounds.top = Math.floor(bounds.top);
			bounds.right = Math.ceil(bounds.right);
			bounds.bottom = Math.ceil(bounds.bottom);

			return bounds;
		}
	}
}
