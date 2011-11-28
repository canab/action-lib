package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.ui.DragController;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.common.utils.MathUtil;

	import flash.display.Sprite;

	internal class ScrollBar extends ControlBase
	{
		private static const PREV:String = "btnPrev";
		private static const NEXT:String = "btnNext";
		private static const LINE:String = "mcLine";
		private static const SCROLLER:String = "btnScroller";

		private var _prevClickEvent:EventSender = new EventSender(this);
		private var _nextClickEvent:EventSender = new EventSender(this);

		protected var _line:Sprite;
		protected var _scrollButton:Sprite;
		protected var _dragController:DragController;
		protected var _scrollPosition:Number = 0;
		protected var _minPosition:int;
		protected var _distance:int;

		private var _changeEvent:EventSender = new EventSender(this);

		public function ScrollBar(content:Sprite)
		{
			wrapContent(content);
			initialize();
		}

		protected function initialize():void
		{
			mouseChildren = true;
			initLine();
			initButtons();
			initPosition();
			initController();
			updateButton();
		}

		private function initController():void
		{
			_dragController = new DragController(_scrollButton);
			_dragController.dragEvent.addListener(onDrag);
			
			applyScrollBounds();
		}

		private function initButtons():void
		{
			new PushButton(getSprite(PREV), _prevClickEvent.dispatch);
			new PushButton(getSprite(NEXT), _nextClickEvent.dispatch);

			_scrollButton = new PushButton(getSprite(SCROLLER));
			_scrollButton.hitArea = null;

			DisplayUtil.addBoundsRect(_scrollButton);
		}

		private function initLine():void
		{
			_line = getSprite(LINE);
			_line.mouseChildren = false;
			_line.mouseEnabled = false;
			_line.cacheAsBitmap = true;
		}

		private virtual function initPosition():void
		{
			var spacing:int = buttonPosition - linePosition;

			_minPosition = linePosition + spacing;
			_distance = lineSize - buttonSize - 2 * spacing;
		}

		private function onDrag():void
		{
			updatePosition();
			refinePosition();
			_changeEvent.dispatch();
		}

		private function refinePosition():void
		{
			if (_scrollPosition > 0.99)
				_scrollPosition = 1.0;
			else if (_scrollPosition < 0.01)
				_scrollPosition = 0.0;
		}

		override protected function applyEnabled():void
		{
			super.applyEnabled();
			mouseChildren = enabled;
			_scrollButton.visible = enabled;
		}

		private function updatePosition():void
		{
			_scrollPosition = (buttonPosition - _minPosition) / _distance;
		}

		private function updateButton():void
		{
			buttonPosition = _minPosition + _scrollPosition * _distance;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// virtual
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected virtual function applyScrollBounds():void
		{
		}

		protected virtual function get buttonPosition():int
		{
			return 0;
		}

		protected virtual function set buttonPosition(value:int):void
		{
		}

		protected virtual function get linePosition():int
		{
			return 0;
		}

		protected virtual function get buttonSize():int
		{
			return 0;
		}

		protected virtual function get lineSize():int
		{
			return 0;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		 //
		 // get/set
		 //
		 ///////////////////////////////////////////////////////////////////////////////////*/

		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}

		public function set scrollPosition(value:Number):void
		{
			_scrollPosition = MathUtil.claimRange(value, 0, 1);
			updateButton();
		}

		public function get changeEvent():EventSender
		{
			return _changeEvent;
		}

		public function get prevClickEvent():EventSender
		{
			return _prevClickEvent;
		}

		public function get nextClickEvent():EventSender
		{
			return _nextClickEvent;
		}

		public function get isScrolling():Boolean
		{
			return _dragController.isActive;
		}
	}
}

