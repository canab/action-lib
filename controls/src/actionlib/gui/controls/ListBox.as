package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.query.from;
	import actionlib.common.utils.ArrayUtil;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.common.utils.MathUtil;
	import actionlib.gui.interfaces.IClickable;
	import actionlib.gui.layouts.VerticalLayout;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ListBox extends ControlBase
	{
//		private static const DEBUG_MORE_ITEMS:Boolean = true;
		private static const DEBUG_MORE_ITEMS:Boolean = false;
		private static const DEBUG_ITEMS_COUNT:int = 25;

		private static const ITEMS_PLACEMENT:String = "mcItemsPlacement";
		private static const SCROLL_BAR:String = "mcScrollBar";
		private static const MASK:String = "mcMask";

		private var _itemClickEvent:EventSender = new EventSender(this);
		private var _itemRenderer:Class;
		private var _items:Object = [];
		private var _mask:Sprite;

		private var _currentItem:Object;
		private var _currentRenderer:ControlBase;

		private var _pageHeight:int;
		private var _outerContainer:Sprite;
		private var _innerContainer:Container;
		private var _scrollBar:ScrollBar;
		private var _spacerRenderer:Class;
		private var _pagePosition:int;

		public function ListBox(content:Sprite, itemRenderer:Class, spacerRenderer:Class = null)
		{
			_itemRenderer = itemRenderer;
			_spacerRenderer = spacerRenderer;
			wrapContent(content);
			initialize();
		}

		private function initialize():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			initContainer();
			initScrollBar();
		}

		private function initScrollBar():void
		{
			_scrollBar = new VerticalScrollBar(getSprite(SCROLL_BAR));
			_scrollBar.changeEvent.addListener(onScroll);
			_scrollBar.prevClickEvent.addListener(onPrevClick);
			_scrollBar.nextClickEvent.addListener(onNextClick);
		}

		private function initContainer():void
		{
			_mask = getSprite(MASK);
			_outerContainer = getSprite(ITEMS_PLACEMENT);
			_pageHeight = _outerContainer.height;

			scrollRect = _mask.getBounds(this);

			DisplayUtil.setScale(_outerContainer, 1.0);
			DisplayUtil.removeChildren(_outerContainer);

			_innerContainer = new Container();
			_innerContainer.layout = new VerticalLayout();
			_innerContainer.mouseChildren = true;

			_outerContainer.addChild(_innerContainer);
			_outerContainer.mask = _mask;

			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function rebuildList():void
		{
			_innerContainer.removeAllControls();

			var renderer:ControlBase = null;

			for each (var item:Object in _items)
			{
				if (renderer && _spacerRenderer)
					_innerContainer.addControl(new _spacerRenderer());

				renderer = new _itemRenderer();
				renderer.data = item;

				if (renderer is IClickable)
					IClickable(renderer).clickEvent.addListener(onItemClick);

				_innerContainer.addControl(renderer);
			}

			invalidate();
		}

		private function onScroll():void
		{
			_pagePosition = maxY - _scrollBar.scrollPosition * (maxY - minY);
			updatePagePosition();
			updateVisibility();
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			movePage(_pagePosition + event.delta * 10);
		}

		private function onPrevClick():void
		{
			movePage(_pagePosition + 0.9 * _pageHeight);
		}

		private function onNextClick():void
		{
			movePage(_pagePosition -0.9 * _pageHeight);
		}

		private function movePage(position:int):void
		{
			_pagePosition = position;
			invalidate();
		}

		private function onItemClick(sender:ControlBase):void
		{
			_currentItem = sender.data;
			_currentRenderer = sender;
			_itemClickEvent.dispatch();
		}

		public function removeItem(item:Object):void
		{
			ArrayUtil.removeItemSafe(_items, item);
			rebuildList();
		}

		override public function applyLayout():void
		{
			super.applyLayout();
			updatePagePosition();
			updateScrollBar();
			updateVisibility();
		}

		private function updatePagePosition():void
		{
			_pagePosition = MathUtil.claimRange(_pagePosition, minY, maxY);
			_innerContainer.y = _pagePosition;
		}

		private function updateScrollBar():void
		{
			_scrollBar.scrollPosition = (maxY == minY) ? 0: (maxY - _innerContainer.y) / (maxY - minY);
			_scrollBar.enabled = _innerContainer.height > _pageHeight;
		}

		private function updateVisibility():void
		{
			for each (var control:ControlBase in _innerContainer.controls)
			{
				control.visible = control.hitTestObject(_mask);
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private function get minY():int
		{
			return Math.min(0.9 * _pageHeight - _innerContainer.height, 0);
		}

		private function get maxY():int
		{
			return 0;
		}

		public function getRenderer(item:Object):ControlBase
		{
			return ControlBase(
					from(_innerContainer.controls)
							.where(function(it:ControlBase):Boolean { return it.data == item })
							.findFirst());
		}

		public function get items():Object
		{
			return _items;
		}

		/**
		 * @param value Vector or Array
		 */
		public function set items(value:Object):void
		{
			_items = value.slice();
			checkDebugOption();
			rebuildList();
			movePage(0);
		}

		private function checkDebugOption():void
		{
			if (DEBUG_MORE_ITEMS && _items.length > 0)
			{
				while (_items.length < DEBUG_ITEMS_COUNT)
				{
					_items.push(ArrayUtil.getRandomItem(_items));
				}
			}
		}

		public function get itemClickEvent():EventSender
		{
			return _itemClickEvent;
		}

		public function get currentItem():Object
		{
			return _currentItem;
		}

		public function get currentRenderer():ControlBase
		{
			return _currentRenderer;
		}
	}
}
