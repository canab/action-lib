package actionlib.engine.scene.renderers
{
	import actionlib.common.events.EventSender;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SpriteRenderer extends DisplayObjectRenderer
	{
		private var _content:Sprite;
		private var _clickEvent:EventSender;
		private var _mouseOverEvent:EventSender;
		private var _mouseOutEvent:EventSender;
		private var _pressEvent:EventSender;

		public function SpriteRenderer(content:Sprite) 
		{
			_content = content;
			_content.mouseEnabled = false;
			_content.mouseChildren = false;
			super(_content);
		}

		private function onClick(event:MouseEvent):void
		{
			_clickEvent.dispatch();
		}

		private function onMouseOver(event:MouseEvent):void
		{
			_mouseOverEvent.dispatch();
		}

		private function onMouseOut(event:MouseEvent):void
		{
			_mouseOutEvent.dispatch();
		}

		private function onPress(event:MouseEvent):void
		{
			_pressEvent.dispatch();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get sprite():Sprite
		{
			return _content as Sprite;
		}

		public function get clickEvent():EventSender
		{
			if (!_clickEvent)
			{
				_clickEvent = new EventSender(this);
				_content.addEventListener(MouseEvent.CLICK, onClick);
			}

			return _clickEvent;
		}

		public function get pressEvent():EventSender
		{
			if (!_pressEvent)
			{
				_pressEvent = new EventSender(this);
				_content.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			}

			return _pressEvent;
		}

		public function get mouseOverEvent():EventSender
		{
			if (!_mouseOverEvent)
			{
				_mouseOverEvent = new EventSender(this);
				_content.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}

			return _mouseOverEvent;
		}

		public function get mouseOutEvent():EventSender
		{
			if (!_mouseOutEvent)
			{
				_mouseOutEvent = new EventSender(this);
				_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}

			return _mouseOutEvent;
		}

	}

}