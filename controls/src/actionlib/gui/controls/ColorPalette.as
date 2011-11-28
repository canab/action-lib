package actionlib.gui.controls
{
	import actionlib.common.events.EventManager;
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.UI;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ColorPalette extends ControlBase
	{
		private static const COLOR_SPRITE_NAME:String = "mcColor";

		private var _colorSelectEvent:EventSender = new EventSender(this);
		private var _finishSelectEvent:EventSender = new EventSender(this);

		private var _colorSprite:Sprite;
		private var _color:int;
		private var _events:EventManager = new EventManager();

		public function ColorPalette(content:Sprite)
		{
			_colorSprite = content[COLOR_SPRITE_NAME];
			mouseChildren = true;
			wrapTarget(content);
			initialize();
		}

		private function initialize():void
		{
			_colorSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_colorSprite.mouseChildren = false;
			_colorSprite.buttonMode = true;
		}

		private function onMouseDown(event:MouseEvent):void
		{
			addListeners();
		}

		private function addListeners():void
		{
			_events.registerNativeEvent(_colorSprite, Event.ENTER_FRAME, onEnterFrame);
			_events.registerNativeEvent(_colorSprite, Event.DEACTIVATE, removeListeners);
			_events.registerNativeEvent(UI.stage, MouseEvent.MOUSE_UP, finishSelecting);
		}

		private function removeListeners(event:Event = null):void
		{
			_events.clearEvents();
		}

		private function onEnterFrame(event:Event):void
		{
			if (!_colorSprite.stage)
			{
				removeListeners();
				return;
			}

			if (_colorSprite.hitTestPoint(_colorSprite.stage.mouseX, _colorSprite.stage.mouseY, true))
			{
				_color = DisplayUtil.getPixel(_colorSprite, _colorSprite.mouseX, _colorSprite.mouseY);
				_colorSelectEvent.dispatch();
			}
		}

		private function finishSelecting(event:Event = null):void
		{
			removeListeners();
			_finishSelectEvent.dispatch();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get colorSelectEvent():EventSender
		{
			return _colorSelectEvent;
		}

		public function get color():int
		{
			return _color;
		}

		public function get finishSelectEvent():EventSender
		{
			return _finishSelectEvent;
		}
	}
}
