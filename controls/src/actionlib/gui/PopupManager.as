package actionlib.gui
{
	import actionlib.common.events.EventManager;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.controls.ControlBase;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	internal class PopupManager extends ManagerBase
	{
		private static const AUTO_HIDE_DISTANCE:int = 50;

		private var _currentControl:ControlBase;
		private var _relatedControl:ControlBase;
		private var _events:EventManager = new EventManager();

		public function PopupManager()
		{
		}

		public function showPopup(control:ControlBase, relatedControl:ControlBase):void
		{
			if (_currentControl)
				hideControl();

			_currentControl = control;
			_relatedControl = relatedControl;

			if (_currentControl)
				showControl();
		}

		private function showControl():void
		{
			DisplayUtil.claimBounds(_currentControl, ui.bounds);

			ui.root.addChild(_currentControl);

			_events.registerNativeEvent(ui.root, Event.DEACTIVATE, hideControl);
			_events.registerNativeEvent(ui.root, Event.ENTER_FRAME, onEnterFrame);
			_events.registerNativeEvent(ui.stage, MouseEvent.MOUSE_DOWN, onMouseDown);

			_events.registerNativeEvent(_relatedControl, Event.REMOVED_FROM_STAGE, hideControl);
			_events.registerNativeEvent(_currentControl, Event.REMOVED_FROM_STAGE, onRemoved);
		}

		private function onEnterFrame(event:Event):void
		{
			var bounds:Rectangle = _currentControl.getBounds(_currentControl);
			bounds.left -= AUTO_HIDE_DISTANCE;
			bounds.top -= AUTO_HIDE_DISTANCE;
			bounds.right += AUTO_HIDE_DISTANCE;
			bounds.bottom += AUTO_HIDE_DISTANCE;

			var mousePos:Point = new Point(_currentControl.mouseX,  _currentControl.mouseY);

			if (!bounds.containsPoint(mousePos) && !hitControl(_relatedControl))
				hideControl();
		}

		private function onMouseDown(event:MouseEvent):void
		{
			if (!hitControl(_currentControl) && !hitControl(_relatedControl))
				hideControl();
		}

		private function hitControl(control:ControlBase):Boolean
		{
			var bounds:Rectangle = control.getBounds(control);
			var mousePos:Point = new Point(control.mouseX,  control.mouseY);
			return bounds.containsPoint(mousePos);
		}

		private function hideControl(event:Event = null):void
		{
			_events.clearEvents();
			DisplayUtil.detachFromDisplay(_currentControl);
			_currentControl = null;
		}

		private function onRemoved(e:Event):void
		{
			_events.clearEvents();
			_currentControl = null;
		}
	}
}
