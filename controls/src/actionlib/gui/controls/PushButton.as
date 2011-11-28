package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.localization.MessageBundle;
	import actionlib.common.query.fromDisplay;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.interfaces.IClickable;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PushButton extends ControlBase implements IClickable
	{
		protected var _upState:DisplayObject;
		protected var _overState:DisplayObject;
		protected var _downState:DisplayObject;
		protected var _currentState:DisplayObject;

		private var _clickEvent:EventSender = new EventSender(this);
		private var _toggled:Boolean;
		private var _allowToggle:Boolean;
		private var _allowResize:Boolean = true;

		public function PushButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			wrapContent(content);
			setBundle(bundle || ControlBase.defaultBundle);
			assignStates();
			initialize();
			setState(_upState);

			if (onClick != null)
				_clickEvent.addListener(onClick);
		}

		override protected function applyEnabled():void
		{
			super.applyEnabled();
			mouseEnabled = enabled;
		}

		private function initialize():void
		{
			_overState.visible = false;
			_downState.visible = false;
			_upState.visible = false;

			hitArea = DisplayUtil.addBoundsRect(this);

			disableMouseFor(_overState, _downState, _upState);

			mouseEnabled = true;
			buttonMode = true;
			cacheAsBitmap = true;

			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			addEventListener(MouseEvent.MOUSE_UP, onRelease);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function assignStates():void
		{
			var children:Array = fromDisplay(this).select();

			_upState = children.pop();
			_overState = (children.length > 0) ? children.pop() : _upState;
			_downState = (children.length > 0) ? children.pop() : _overState;
		}

		protected function onClick(event:MouseEvent):void
		{
			if (allowToggle)
				toggled = !toggled;

			clickEvent.dispatch();
		}

		protected function onOver(event:MouseEvent):void
		{
			if (!_toggled)
				setState(_overState);
		}

		protected function onOut(e:MouseEvent):void
		{
			if (!_toggled)
				setState(_upState);
		}

		protected function onPress(event:MouseEvent):void
		{
			if (!_toggled)
				setState(_downState);
		}

		protected function onRelease(event:MouseEvent):void
		{
			if (!_toggled)
				setState(_overState);
		}

		protected function setState(state:DisplayObject):void
		{
			if (_currentState)
				_currentState.visible = false;

			_currentState = state;

			if (_currentState)
				_currentState.visible = true;
		}

		override public virtual function applyLayout():void
		{
			if (_allowResize)
			{
				hitArea.width = width;
				hitArea.height = height;

				_upState.width = width;
				_upState.height = height;

				_overState.width = width;
				_overState.height = height;

				_downState.width = width;
				_downState.height = height;
			}
		}

		protected function ignoreObject(target:InteractiveObject):void
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, stopEventPropagation);
			target.addEventListener(MouseEvent.MOUSE_UP, stopEventPropagation);
			target.addEventListener(MouseEvent.CLICK, stopEventPropagation);
		}

		private function stopEventPropagation(event:MouseEvent):void
		{
			event.stopPropagation();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get clickEvent():EventSender
		{
			return _clickEvent;
		}

		public function get toggled():Boolean
		{
			return _toggled;
		}

		public function set toggled(value:Boolean):void
		{
			if (_toggled != value)
			{
				_toggled = value;

				if (_toggled)
					setState(_downState);
				else
					setState(_upState);
			}
		}

		public function get allowToggle():Boolean
		{
			return _allowToggle;
		}

		public function set allowToggle(value:Boolean):void
		{
			_allowToggle = value;
		}

		public function get allowResize():Boolean
		{
			return _allowResize;
		}

		public function set allowResize(value:Boolean):void
		{
			_allowResize = value;
		}
	}
}