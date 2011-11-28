package actionlib.engine.scene.renderers
{
	import actionlib.engine.rendering.BitmapFrame;
	import actionlib.engine.rendering.ClipPrerenderer;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class BitmapClipRenderer extends ClipRenderer
	{
		public static function captureClip(target:Sprite):BitmapClipRenderer
		{
			var prerenderer:ClipPrerenderer = new ClipPrerenderer(target);
			prerenderer.renderAllFrames();

			var renderer:BitmapClipRenderer = new BitmapClipRenderer(prerenderer.frames);
			renderer.content.x = int(target.x);
			renderer.content.y = int(target.y);

			return renderer;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/


		private var _content:Sprite;

		private var _frames:Vector.<BitmapFrame>;
		private var _bitmap:Bitmap = new Bitmap();

		public function BitmapClipRenderer(frames:Vector.<BitmapFrame> = null)
		{
			super(_content = new Sprite());

			_frames = frames;
			_content.addChild(_bitmap);

			if (_frames)
				updateFrame();
		}

		override protected function updateFrame():void
		{
			var frame:BitmapFrame = _frames[currentFrame - 1];
			
			if (frame)
			{
				_bitmap.bitmapData = frame.data;
				_bitmap.x = frame.x;
				_bitmap.y = frame.y;
			}
			else
			{
				_bitmap.bitmapData = null;
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get frames():Vector.<BitmapFrame>
		{
			return _frames;
		}

		public function set frames(value:Vector.<BitmapFrame>):void
		{
			_frames = value;
			currentFrame = 1;
			updateFrame();
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		override public function get totalFrames():int
		{
			return _frames.length;
		}
	}
}
