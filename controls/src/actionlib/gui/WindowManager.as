package actionlib.gui
{
	import actionlib.common.query.conditions.nameIs;
	import actionlib.common.query.from;
	import actionlib.common.ui.DragController;
	import actionlib.common.ui.KeyboardManager;
	import actionlib.common.utils.ArrayUtil;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.controls.WindowBase;

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	use namespace ui_internal;

	internal class WindowManager extends ManagerBase
	{
		private var _windows:Vector.<WindowBase> = new <WindowBase>[];
		private var _dialogs:Vector.<WindowBase> = new <WindowBase>[];
		private var _currentScreen:WindowBase;
		private var _activeWindow:WindowBase;

		private var _modalFrame:Sprite = new Sprite();

		public function WindowManager()
		{
			super();
			initialize();
		}

		private function initialize():void
		{
			KeyboardManager.pressEvent.addListener(onKeyPress);
		}

		//noinspection JSUnusedLocalSymbols
		private function onKeyPress(sender:KeyboardManager, event:KeyboardEvent):void
		{
			if (UI.locked)
				return;

			if (_activeWindow)
				_activeWindow.processKey(event);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// screens
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function changeScreen(screen:WindowBase):void
		{
			removeScreen();
			addScreen(screen);
			UI.events.screenChanged.dispatch();
		}

		private function addScreen(screen:WindowBase):void
		{
			_currentScreen = screen;
			attachWindow(_currentScreen, 0);

			if (!dialogExists)
				activateWindow(screen);
		}

		public function removeScreen():void
		{
			if (_currentScreen)
			{
				deactivateWindow(_currentScreen);
				detachWindow(_currentScreen);
				_currentScreen = null;
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// dialogs
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function showDialog(window:WindowBase, position:Point = null):void
		{
			window.closeEvent.addListener(hideDialog);
			window.position = position || getDialogPosition(window);

			ArrayUtil.addItemSafe(_dialogs, window);
			attachWindow(window);
			createModalFrame();
			refreshModalFrame();
			activateWindow(window);
		}

		public function hideDialog(window:WindowBase = null):void
		{
			if (!window)
				window = WindowBase(ArrayUtil.lastItem(_dialogs));

			deactivateWindow(window);
			detachWindow(window);
			ArrayUtil.removeItemSafe(_dialogs, window);
			window.closeEvent.removeListener(hideDialog);

			refreshModalFrame();
			tryActivateNext();
		}

		private function createModalFrame():void
		{
			_modalFrame.graphics.clear();
			_modalFrame.graphics.beginFill(DefaultStyle.modalColor, DefaultStyle.modalAlpha);
			_modalFrame.graphics.drawRect(0, 0, 100, 100);
			_modalFrame.graphics.endFill();
		}

		private function refreshModalFrame():void
		{
			if (_modalFrame.parent)
				DisplayUtil.detachFromDisplay(_modalFrame);

			if (!dialogExists)
				return;

			var dialog:WindowBase = WindowBase(ArrayUtil.lastItem(_dialogs));
			var depth:int = ui.root.getChildIndex(dialog);

			ui.root.addChildAt(_modalFrame, depth);

			_modalFrame.width = ui.bounds.width;
			_modalFrame.height = ui.bounds.height;
		}

		private function getDialogPosition(window:WindowBase):Point
		{
			var x:Number = 0.5 * (ui.bounds.width - window.width);
			var y:Number = 0.5 * (ui.bounds.height - window.height);
			return new Point(Math.max(x, 0), Math.max(y, 0));
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// windows
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function addWindow(window:WindowBase):void
		{
			ArrayUtil.addItemSafe(_windows, window);
			attachWindow(window);
			new DragController(window, window.hitArea).bounds = ui.bounds;
			window.closeEvent.addListener(removeWindow);
			window.addEventListener(MouseEvent.MOUSE_DOWN, onWindowMouseDown);
		}

		public function removeWindow(window:WindowBase):void
		{
			window.closeEvent.removeListener(removeWindow);
			ArrayUtil.removeItemSafe(_windows, window);
			detachWindow(window);
		}

		private function onWindowMouseDown(event:MouseEvent):void
		{
			var window:WindowBase = WindowBase(event.currentTarget);
			activateWindow(window);
			DisplayUtil.bringToFront(window);
		}

		public function removeAllWindows():void
		{
			var windows:Vector.<WindowBase> = _windows.slice();
			for each (var window:WindowBase in windows)
			{
				removeWindow(window);
			}
		}

		public function hideAllWindows():void
		{
			for each (var window:WindowBase in _windows)
			{
				window.visible = false;
			}
		}

		public function showAllWindows():void
		{
			for each (var window:WindowBase in _windows)
			{
				window.visible = true;
			}
		}

		public function getWindow(windowName:String):WindowBase
		{
			return WindowBase(
					from(_windows)
							.where(nameIs(windowName))
							.findFirst());
		}

		public function hasWindow(windowName:String):Boolean
		{
			return from(_windows)
					.where(nameIs(windowName))
					.exists();
		}

		private function attachWindow(window:WindowBase, depth:int = -1):void
		{
			if (depth == -1)
				ui.root.addChild(window);
			else
				ui.root.addChildAt(window, depth);

			window.processAdd();
			
			UI.events.windowAdded.dispatch(window);
		}

		private function detachWindow(window:WindowBase):void
		{
			window.processRemove();
			DisplayUtil.detachFromDisplay(window);
			UI.events.windowRemoved.dispatch(window);
		}

		public function activateWindow(window:WindowBase):void
		{
			if (UI.locked)
				return;

			if (window == _activeWindow)
				return;

			if (_activeWindow)
				deactivateWindow(_activeWindow);

			_activeWindow = window;
			_activeWindow.activate();
		}

		internal function deactivateWindow(window:WindowBase):void
		{
			if (window == _activeWindow)
			{
				_activeWindow.deactivate();
				_activeWindow = null;
			}
		}

		private function tryActivateNext():void
		{
			if (dialogExists)
				activateWindow(ArrayUtil.lastItem(_dialogs) as WindowBase);
			else if (_currentScreen)
				activateWindow(_currentScreen);
		}

		internal function bringWindowToFront(window:WindowBase):void
		{
			activateWindow(window);
			DisplayUtil.bringToFront(window);
		}

		internal function get dialogExists():Boolean
		{
			return _dialogs.length > 0;
		}

		internal function get currentScreen():WindowBase
		{
			return _currentScreen;
		}

		internal function get activeWindow():WindowBase
		{
			return _activeWindow;
		}
	}
}
