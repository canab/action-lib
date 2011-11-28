package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.common.utils.AlignUtil;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.UI;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class ControlBase extends Sprite
	{
		public static var defaultBundle:MessageBundle;
		public static var loaderViewClass:Class;

		private static var _validateList:Array = [];
		private static var _isRenderPhase:Boolean =  false;

		private static function addToValidationList(control:ControlBase):void
		{
			if (_validateList.length == 0)
			{
				UI.stage.addEventListener(Event.RENDER, validateControls);
				UI.stage.invalidate();
			}

			_validateList.push(control);
		}

		private static function validateControls(event:Event):void
		{
			UI.stage.removeEventListener(Event.RENDER, validateControls);

			_isRenderPhase = true;

			for each (var control:ControlBase in _validateList)
			{
				control.validate();
			}

			_isRenderPhase = false;
			_validateList = [];
		}


		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected var _width:Number = -1;
		protected var _height:Number = -1;
		protected var _data:Object;

		private var _bundle:MessageBundle;
		private var _enabled:Boolean = true;
		private var _disabledAlpha:Number = 0.5;
		private var _invalidated:Boolean = false;

		private var _tooltip:String;
		private var _loadingClip:Sprite;

		private var _x:Number = 0;
		private var _y:Number = 0;

		public function ControlBase()
		{
			mouseEnabled = false;
			mouseChildren = false;
		}

		public function move(x:Number, y:Number):void
		{
			_x = x;
			_y = y;

			super.x = int(_x);
			super.y = int(_y);
		}

		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;

			invalidate();
		}

		public function wrapContent(target:DisplayObjectContainer):void
		{
			if (target.numChildren == 0)
				throw new Error("Target is already wrapped");

			name = target.name;

			while (target.numChildren > 0)
			{
				addChild(target.getChildAt(0));
			}

			replaceTarget(target);
		}

		public function wrapTarget(target:DisplayObject):void
		{
			name = target.name;
			replaceTarget(target);
			addChild(target);
			target.x = 0;
			target.y = 0;
		}

		protected function replaceTarget(target:DisplayObject):void
		{
			x = target.x;
			y = target.y;

			var container:DisplayObjectContainer = target.parent;

			if (container)
			{
				container.addChildAt(this, container.getChildIndex(target));
				container.removeChild(target);
			}
		}

		protected function applyEnabled():void
		{
			alpha = _enabled ? 1.0 : _disabledAlpha;
		}

		public function setPlacement(source:Sprite):void
		{
			move(source.x, source.y);
			setSize(source.width, source.height);
		}

		public function applyLayout():void
		{
			if (_loadingClip)
				applyLoadingClipLayout();
		}

		private function applyLoadingClipLayout():void
		{
			AlignUtil.alignCenter(_loadingClip, new Rectangle(0, 0, width, height));
		}

		public function showLoading():void
		{
			_loadingClip = new loaderViewClass();
			addChild(_loadingClip);
			applyLoadingClipLayout();
		}

		public function hideLoading():void
		{
			DisplayUtil.stopAllClips(_loadingClip);
			DisplayUtil.detachFromDisplay(_loadingClip);
		}

		protected function getSprite(name:String):Sprite
		{
			return Sprite(getChildByName(name));
		}

		protected function getField(name:String):TextField
		{
			return TextField(getChildByName(name));
		}

		protected virtual function applyData():void {}

		protected virtual function applyLocalization():void {}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// localization
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected function setBundle(value:MessageBundle):void
		{
			if (_bundle)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

				if (stage)
					onRemovedFromStage(null);
			}

			_bundle = value;

			if (_bundle)
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

				if (stage)
					onAddedToStage(null);
			}
		}

		private function onAddedToStage(e:Event):void
		{
			_bundle.changeEvent.addListener(applyLocalization);
		}

		private function onRemovedFromStage(e:Event):void
		{
			_bundle.changeEvent.removeListener(applyLocalization);
		}

		protected function handle(func:Function):void
		{
			if (func != null)
				func();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override public function get width():Number
		{
			return (_width == -1) ? super.width : _width;
		}

		override public function set width(value:Number):void
		{
			if (_width != value)
				setSize(value, height);
		}

		override public function get height():Number
		{
			return (_height == -1) ? super.height : _height;
		}

		override public function set height(value:Number):void
		{
			if (_height != value)
				setSize(width, value);
		}

		override public function get x():Number
		{
			return _x;
		}

		override public function set x(value:Number):void
		{
			move(value,  y);
		}

		override public function get y():Number
		{
			return _y;
		}

		override public function set y(value:Number):void
		{
			move(x, value);
		}

		public function get bundle():MessageBundle
		{
			return _bundle;
		}

		public function set bundle(value:MessageBundle):void
		{
			setBundle(value);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if (_data != value)
			{
				_data = value;
				applyData();
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				applyEnabled();
			}
		}

		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}

		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
			applyEnabled();
		}

		public function get tooltip():String
		{
			return _tooltip;
		}

		public function set tooltip(value:String):void
		{
			if (_tooltip != value)
			{
				_tooltip = value;

				if (_tooltip)
					UI.registerTooltip(this, _tooltip, bundle);
				else
					UI.unregisterTooltip(this);
			}
		}

		protected function disableMouseFor(...args):void
		{
			for each (var item:DisplayObject in args)
			{
				if (item is InteractiveObject)
					InteractiveObject(item).mouseEnabled = false;

				if (item is DisplayObjectContainer)
					DisplayObjectContainer(item).mouseChildren = false;
			}
		}

		public function invalidate():void
		{
			if (!_invalidated)
			{
				_invalidated = true;

				if (_isRenderPhase)
					validate();
				else
					addToValidationList(this);
			}
		}

		public function validate():void
		{
			if (_invalidated)
			{
				_invalidated = false;
				applyLayout();
			}
		}

		public function get position():Point
		{
			return new Point(x, y);
		}

		public function set position(value:Point):void
		{
			move(value.x,  value.y);
		}
	}
}