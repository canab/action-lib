package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.ColorUtil;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.UI;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	public class ColorPicker extends ControlBase
	{
		private var _colorSelectEvent:EventSender = new EventSender(this);
		private var _paletteHideEvent:EventSender = new EventSender(this);

		private var _color:int = 0xFFFFFF;
		private var _paletteContentClass:Class;
		private var _palette:ColorPalette;

		public function ColorPicker(content:Sprite, paletteContentClass:Class)
		{
			_paletteContentClass = paletteContentClass;
			mouseChildren = true;
			wrapTarget(content);
			initialize();
		}

		private var _button:ImageButton;

		private function initialize():void
		{
			var buttonContent:Sprite = Sprite(this.getChildAt(0));
			_button = new ImageButton(buttonContent, onButtonClick);
			_button.disabledAlpha = 0.25;
		}

		private function onButtonClick():void
		{
			if (_palette)
				hidePalette();
			else
				showPalette();
		}

		private function showPalette():void
		{
			_palette = new ColorPalette(new _paletteContentClass());
			_palette.colorSelectEvent.addListener(onColorSelect);
			_palette.finishSelectEvent.addListener(hidePalette);
			_palette.addEventListener(Event.REMOVED_FROM_STAGE, disposePalette);

			_palette.x = x;
			_palette.y = y + _button.height + 4;

			UI.showPopup(_palette, _button);
		}

		private function onColorSelect():void
		{
			color = _palette.color;
			_colorSelectEvent.dispatch();
		}

		private function hidePalette():void
		{
			DisplayUtil.detachFromDisplay(_palette);
		}

		private function disposePalette(event:Event = null):void
		{
			_paletteHideEvent.dispatch();
			_palette = null;
		}

		private function refresh():void
		{
			var rgb:Object = ColorUtil.toRGB(_color);
			
			_button.image.transform.colorTransform = new ColorTransform(
						rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0);
		}

		override protected function applyEnabled():void
		{
			_button.enabled = enabled;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get color():int
		{
			return _color;
		}

		public function set color(value:int):void
		{
			_color = value;
			refresh();
		}

		public function get colorSelectEvent():EventSender
		{
			return _colorSelectEvent;
		}

		override public function set visible(value:Boolean):void
		{
			super.visible = value;

			if (_palette)
				hidePalette();
		}

		public function get paletteHideEvent():EventSender
		{
			return _paletteHideEvent;
		}

		public function set paletteHideEvent(value:EventSender):void
		{
			_paletteHideEvent = value;
		}
	}
}
