package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.gui.interfaces.IClickable;
	import actionlib.gui.interfaces.ILayout;
	import actionlib.gui.layouts.GridLayout;
	import actionlib.motion.easing.Linear;
	import actionlib.motion.tween;

	import flash.display.Sprite;

	public class PagedContainer extends ControlBase
	{
		private static const PREV_BUTTON:String = "btnPrev";
		private static const NEXT_BUTTON:String = "btnNext";
		private static const ITEMS_PLACEMENT:String = "mcItemsPlacement";
		private static const MASK:String = "mcMask";

		private static const SPACING_MULT:Number = 0.1;

		private var _itemClickEvent:EventSender = new EventSender(this);

		private var _items:Object = [];
		private var _itemRenderer:Class;
		private var _pageNum:int = 0;
		private var _pageCount:int;
		private var _itemsPerPage:int;

		private var _nextButton:PushButton;
		private var _prevButton:PushButton;
		private var _buttonExists:Boolean;
		
		private var _pageContainer:Container;
		private var _itemsContent:Sprite;
		private var _itemsLayout:ILayout;
		private var _gap:int;

		public function PagedContainer(content:Sprite, itemRenderer:Class, gap:int = -1)
		{
			_itemRenderer = itemRenderer;
			_gap = gap;

			wrapContent(content);
			initialize();
		}

		private function initialize():void
		{
			mouseChildren = true;
			initButtons();
			initContainer();
			refresh();
		}

		private function initButtons():void
		{
			_buttonExists = Boolean(getChildByName(PREV_BUTTON));

			if (_buttonExists)
			{
				_prevButton = new PushButton(getSprite(PREV_BUTTON), onPrevClick);
				_nextButton = new PushButton(getSprite(NEXT_BUTTON), onNextClick);
			}
		}

		private function initContainer():void
		{
			var renderer:ControlBase = new _itemRenderer();
			var placement:Sprite = getSprite(ITEMS_PLACEMENT);
			DisplayUtil.detachFromDisplay(placement);

			if (_gap == -1)
				_gap = renderer.width * SPACING_MULT;

			var numRows:int = Math.max((placement.height + _gap) / (renderer.height + _gap), 1);
			var numCols:int = Math.max((placement.width + _gap) / (renderer.width + _gap), 1);

			var contentWidth:int = numCols * renderer.width + (numCols - 1) * _gap;
			var contentHeight:int = numRows * renderer.height + (numRows - 1) * _gap;

			addChild(_itemsContent = new Sprite());
			
			_itemsContent.x = int(placement.x + 0.5 * placement.width - 0.5 * contentWidth);
			_itemsContent.y = int(placement.y + 0.5 * placement.height - 0.5 * contentHeight);
			_itemsContent.mouseEnabled = false;
			_itemsContent.mask = getSprite(MASK);

			_itemsPerPage = numRows * numCols;
			_itemsLayout = new GridLayout(renderer.width + _gap, renderer.height + _gap, numCols);
		}

		private function refresh():void
		{
			_pageCount = Math.ceil(_items.length / _itemsPerPage);

			if (_buttonExists)
			{
				_prevButton.visible = _pageCount > 1;
				_nextButton.visible = _pageCount > 1;

				_prevButton.enabled = _pageNum > 0;
				_nextButton.enabled = _pageNum < _pageCount - 1;
			}

			createPage();
		}

		private function createPage():void
		{
			if (_pageContainer)
				DisplayUtil.detachFromDisplay(_pageContainer);

			_pageContainer = new Container();
			_pageContainer.mouseChildren = true;
			_pageContainer.layout = _itemsLayout;
			
			_itemsContent.addChild(_pageContainer);

			var firstIndex:int = _pageNum * _itemsPerPage;
			var lastIndex:int = Math.min(firstIndex + _itemsPerPage, _items.length);

			for (var i:int = firstIndex; i < lastIndex; i++)
			{
				var renderer:ControlBase = new _itemRenderer();
				renderer.data = _items[i];

				if (renderer is IClickable)
					IClickable(renderer).clickEvent.addListener(onItemClick);

				_pageContainer.addControl(renderer);
			}
		}

		private function onItemClick(sender:ControlBase):void
		{
			_itemClickEvent.dispatch(sender.data);
		}

		private function onPrevClick():void
		{
			hideContainer(_pageContainer.width);
			_pageNum--;
			refresh();
			showContainer(-_pageContainer.width);
		}

		private function onNextClick():void
		{
			hideContainer(-_pageContainer.width);
			_pageNum++;
			refresh();
			showContainer(_pageContainer.width);
		}

		private function showContainer(fromX:int):void
		{
			_pageContainer.x = 1.3 * fromX;
			_pageContainer.alpha = 0;
			
			tween(_pageContainer, 500)
					.easing(Linear.easeNone)
					.to({x: 0, alpha: 1});
		}

		private function hideContainer(toX:int):void
		{
			_pageContainer.mouseChildren = false;
			_pageContainer.cacheAsBitmap = true;

			tween(_pageContainer, 300)
					.easing(Linear.easeNone)
					.to({x: toX, alpha: 0})
					.onComplete(DisplayUtil.detachFromDisplay, _pageContainer);

			_pageContainer = null;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get items():Object
		{
			return _items;
		}

		/**
		 *
		 * @param value Vector or Array
		 */
		public function set items(value:Object):void
		{
			_items = value;
			_pageNum = 0;

			refresh();
		}

		public function get itemClickEvent():EventSender
		{
			return _itemClickEvent;
		}

		public function get renderers():Array
		{
			return _pageContainer.controls;
		}
	}
}
