package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MotionTestBase
	{
		private var _root:Sprite;

		public function MotionTestBase()
		{
			super()
		}

		public function initialize(root:Sprite):void
		{
			_root = root;
			_root.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_root.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_root.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_root.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			onInitialize();
		}

		protected function createSprite(x:Number = 300, y:Number = 150):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x0000FF);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			sprite.x = x;
			sprite.y = y;

			_root.addChild(sprite);

			return sprite;
		}

		protected function onInitialize():void
		{
			// virtual
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			// virtual
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			// virtual
		}


	}
}
