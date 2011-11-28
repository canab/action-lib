package actionlib.gui.controls
{
	import actionlib.common.events.EventManager;
	import actionlib.common.events.EventSender;
	import actionlib.gui.ui_internal;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.getQualifiedClassName;

	use namespace ui_internal;

	public class WindowBase extends ControlBase
	{
		private var _closeEvent:EventSender = new EventSender(this);
		private var _events:EventManager;
		private var _wasActivated:Boolean = false;

		public function WindowBase(name:String = null)
		{
			this.name = name || getQualifiedClassName(this);
			this.focusRect = false;
			mouseChildren = true;
		}

		override protected function applyEnabled():void
		{
			this.mouseChildren = enabled;
		}

		ui_internal function activate():void
		{
			stage.focus = this;

			onActivate();

			if (!_wasActivated)
			{
				_wasActivated = true;
				onFirstActivate();
			}
		}

		ui_internal function deactivate():void
		{
			onDeactivate();
		}

		ui_internal function processAdd():void
		{
			onAdd();
		}

		ui_internal function processRemove():void
		{
			if (_events)
				_events.clearEvents();

			onRemove();
		}

		ui_internal function processKey(event:KeyboardEvent):void
		{
			onKeyPress(event);
		}

		protected function closeWindow():void
		{
			_closeEvent.dispatch();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// events
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function registerEvent(event:EventSender, handler:Function):void
		{
			events.registerEvent(event, handler);
		}

		public function unregisterEvent(event:EventSender, handler:Function):void
		{
			events.unregisterEvent(event, handler);
		}

		public function registerNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			events.registerNativeEvent(object, type, listener, useCapture);
		}

		public function unregisterNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			events.unregisterNativeEvent(object, type, listener, useCapture);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// virtual
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected virtual function onAdd():void {}

		protected virtual function onActivate():void {}

		protected virtual function onFirstActivate():void {}

		protected virtual function onKeyPress(e:KeyboardEvent):void {}

		protected virtual function onDeactivate():void {}

		protected virtual function onRemove():void {}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private function get events():EventManager
		{
			if (!_events)
				_events = new EventManager();

			return _events;
		}

		override public function get hitArea():Sprite
		{
			return super.hitArea;
		}

		override public function set hitArea(value:Sprite):void
		{
			super.hitArea = value;
			hitArea.mouseChildren = false;
			hitArea.buttonMode = true;
		}

		public function get closeEvent():EventSender
		{
			return _closeEvent;
		}
	}
}
