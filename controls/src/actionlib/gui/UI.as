package actionlib.gui
{
	import actionlib.common.display.StageReference;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.localization.MessageBundle;
	import actionlib.gui.controls.ControlBase;
	import actionlib.gui.controls.WindowBase;
	import actionlib.gui.interfaces.ITooltip;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UI
	{
		private static var _instance:UI;

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// initialization
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public static function initialize(root:Sprite, bounds:Rectangle):void
		{
			if (initialized)
				throw new AlreadyInitializedError();

			_instance = new UI(new PrivateConstructor());
			_instance.initialize(root, bounds);
		}

		public static function get initialized():Boolean
		{
			return Boolean(_instance);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// windows
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public static function addWindow(window:WindowBase):void
		{
			instance.windowManager.addWindow(window);
		}

		public static function removeWindow(window:WindowBase):void
		{
			instance.windowManager.removeWindow(window);
		}

		public static function removeAllWindows():void
		{
			instance.windowManager.removeAllWindows();
		}

		public static function hideAllWindows():void
		{
			instance.windowManager.hideAllWindows();
		}

		public static function showAllWindows():void
		{
			instance.windowManager.showAllWindows();
		}

		public static function get activeWindow():WindowBase
		{
			return instance.windowManager.activeWindow;
		}

		public static function getWindow(windowName:String):WindowBase
		{
			return instance.windowManager.getWindow(windowName);
		}

		public static function hasWindow(windowName:String):Boolean
		{
			return instance.windowManager.hasWindow(windowName);
		}

		public static function bringToFront(window:WindowBase):void
		{
			instance.windowManager.bringWindowToFront(window);
		}

		public static function showDialog(window:WindowBase, position:Point = null):void
		{
			instance.windowManager.showDialog(window, position);
		}

		public static function hideDialog(window:WindowBase = null):void
		{
			instance.windowManager.hideDialog(window);
		}

		public static function showPopup(control:ControlBase, relatedControl:ControlBase):void
		{
			instance.popupManager.showPopup(control, relatedControl);
		}

		public static function get dialogExists():Boolean
		{
			return instance.windowManager.dialogExists;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// tooltips
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public static function registerTooltip(target:DisplayObject, message:String, bundle:MessageBundle = null):void
		{
			instance.tooltipManager.registerObject(target, message, bundle);
		}

		public static function unregisterTooltip(target:DisplayObject):void
		{
			instance.tooltipManager.unregisterObject(target);
		}

		public static function get tooltipRenderer():ITooltip
		{
			return instance.tooltipRenderer;
		}

		public static function set tooltipRenderer(value:ITooltip):void
		{
			instance.tooltipRenderer = value;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// screens
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public static function changeScreen(screen:WindowBase):void
		{
			instance.windowManager.changeScreen(screen);
		}

		public static function removeScreen():void
		{
			instance.windowManager.removeScreen();
		}

		public static function get currentScreen():WindowBase
		{
			return instance.windowManager.currentScreen;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public static function get stage():Stage
		{
			return instance.stage;
		}

		internal static function get instance():UI
		{
			if (!initialized)
				throw new NotInitializedError();

			return _instance;
		}

		public static function get locked():Boolean
		{
			return instance.locked;
		}

		public static function set locked(value:Boolean):void
		{
			instance.locked = value;
		}

		public static function get events():UIEvents
		{
			return instance.events;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _root:Sprite;
		private var _bounds:Rectangle;
		private var _events:UIEvents = new UIEvents();

		private var _popupManager:PopupManager;
		private var _tooltipManager:ToolTipManager;
		private var _windowManager:WindowManager;
		private var _locked:Boolean;

		internal var tooltipRenderer:ITooltip;

		//noinspection JSUnusedLocalSymbols
		public function UI(param:PrivateConstructor)
		{
		}

		public function initialize(root:Sprite, bounds:Rectangle):void
		{
			_root = root;
			_bounds = bounds;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get root():Sprite
		{
			return _root;
		}

		public function get bounds():Rectangle
		{
			return _bounds;
		}

		public function get popupManager():PopupManager
		{
			if (!_popupManager)
				_popupManager = new PopupManager();

			return _popupManager;
		}

		public function get stage():Stage
		{
			return StageReference.stage;
		}

		public function get tooltipManager():ToolTipManager
		{
			if (!_tooltipManager)
				_tooltipManager = new ToolTipManager();
			
			return _tooltipManager;
		}

		public function get windowManager():WindowManager
		{
			if (!_windowManager)
				_windowManager = new WindowManager();

			return _windowManager;
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			if (_locked != value)
			{
				_locked = value;

				if (_locked)
					lock();
				else
					unlock();
			}
		}

		private function lock():void
		{
			_root.mouseChildren = false;
		}

		private function unlock():void
		{
			_root.mouseChildren = true;
		}

		public function get events():UIEvents
		{
			return _events;
		}
	}

}

internal class PrivateConstructor {}
