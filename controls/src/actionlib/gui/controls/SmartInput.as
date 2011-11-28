package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.StringUtil;
	import actionlib.gui.utils.TextUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class SmartInput extends ControlBase
	{
		private var _changeEvent:EventSender = new EventSender(this);
		private var _wrongCharEvent:EventSender = new EventSender(this);

		private var _field:TextField;
		private var _background:MovieClip;

		private var _text:String;
		private var _margins:int = 10;
		private var _fitTextToWidth:Boolean = false;

		private var _changeFlag:Boolean;

		public function SmartInput(content:Sprite)
		{
			_background = MovieClip(content.getChildAt(0));
			_field = TextField(content.getChildAt(1));

			wrapContent(content);
			initialize();
		}

		private function initialize():void
		{
			_background.gotoAndStop(1);

			_field.multiline = false;
			_field.wordWrap = false;

			_field.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_field.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_field.addEventListener(Event.CHANGE, onTextChange);
			_field.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_field.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);

			TextUtil.initInputField(field);
			mouseChildren = true;
			text = "";
		}

		private function onFocusOut(e:FocusEvent):void
		{
			_background.gotoAndStop(1);
		}

		private function onFocusIn(e:FocusEvent):void
		{
			_background.gotoAndStop(2);
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			if (!_changeFlag
					&& e.charCode >= 32
					&& e.charCode != 127
					&& _field.maxChars > 0
					&& _field.text.length < _field.maxChars)
			{
				_wrongCharEvent.dispatch();
			}
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			_changeFlag = false;
		}

		public function set cursorPosition(position:int):void
		{
			_field.setSelection(position, position);
		}

		private function onTextChange(e:Event):void
		{
			_changeFlag = true;

			if (!_fitTextToWidth || _fitTextToWidth && checkTextWidth())
			{
				_text = _field.text;
				_changeEvent.dispatch();
			}
		}

		private function checkTextWidth():Boolean
		{
			var fitted:Boolean = (_field.textWidth + 4 < _field.width);

			if (!fitted)
			{
				_field.text = _text;
				_field.scrollH = 0;
			}

			return fitted;
		}

		public function get focused():Boolean
		{
			return (_field.stage && _field.stage.focus == _field);
		}

		public function set focused(value:Boolean):void
		{
			if (value)
				_field.stage.focus = _field;
		}

		public function set text(value:String):void
		{
			_text = StringUtil.trim(value);
			_field.text = _text;

			cursorPosition = _text.length;
		}

		public function get isEmpty():Boolean
		{
			return text.length == 0;
		}

		public function setErrorState():void
		{
			_background.gotoAndStop(3);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get fitTextToWidth():Boolean
		{
			return _fitTextToWidth;
		}

		public function set fitTextToWidth(value:Boolean):void
		{
			_fitTextToWidth = value;
		}

		public function get margins():int
		{
			return _margins;
		}

		public function set margins(value:int):void
		{
			_margins = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function get restrict():String
		{
			return _field.restrict;
		}

		public function set restrict(value:String):void
		{
			_field.restrict = value;
		}

		public function get field():TextField
		{
			return _field;
		}

		public function get changeEvent():EventSender
		{
			return _changeEvent;
		}

		public function get wrongCharEvent():EventSender
		{
			return _wrongCharEvent;
		}

		public function get displayAsPassword():Boolean
		{
			return _field.displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			_field.displayAsPassword = value;
		}

		public function get maxChars():int
		{
			return _field.maxChars;
		}

		public function set maxChars(value:int):void
		{
			_field.maxChars = value;
		}
	}

}