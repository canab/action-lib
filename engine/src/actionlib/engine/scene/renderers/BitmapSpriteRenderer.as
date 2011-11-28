package actionlib.engine.scene.renderers
{
	import actionlib.common.utils.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class BitmapSpriteRenderer extends SpriteRenderer
	{
		private var _content:Sprite;

		public function BitmapSpriteRenderer(bitmap:Bitmap)
		{
			super(_content = new Sprite());
			_content.addChild(bitmap);
		}

		public static function captureSprite(target:Sprite):BitmapSpriteRenderer
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
	}
}
