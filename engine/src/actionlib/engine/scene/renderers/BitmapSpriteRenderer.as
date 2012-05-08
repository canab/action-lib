package actionlib.engine.scene.renderers
{
	import actionlib.common.utils.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class BitmapSpriteRenderer extends SpriteRenderer
	{
		public static function captureSprite(target:DisplayObject):BitmapSpriteRenderer
		{
			var container:Sprite = new Sprite();
			container.addChild(target);

			var bounds:Rectangle = BitmapUtil.calculateIntBounds(container);
			var bitmap:Bitmap = BitmapUtil.convertToBitmap(container, bounds);
			bitmap.x = Math.round(bounds.x - target.x);
			bitmap.y = Math.round(bounds.y - target.y);

			var renderer:BitmapSpriteRenderer = new BitmapSpriteRenderer(bitmap);
			renderer.content.x = Math.round(target.x);
			renderer.content.y = Math.round(target.y);

			return renderer;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private var _content:Sprite;
		private var _bitmap:Bitmap;
		private var _smoothing:Boolean = false;

		public function BitmapSpriteRenderer(bitmap:Bitmap)
		{
			super(_content = new Sprite());
			_content.addChild(bitmap);
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function get smoothing():Boolean { return _smoothing; }

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;

			if (_bitmap)
				_bitmap.smoothing = value;
		}
	}
}
