package actionlib.common.query.iterators
{
	import actionlib.common.query.fromDisplayTree;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public class ButtonIterator extends Proxy
	{
		private var _items:Array = [];
		private var _index:int = 0;

		public function ButtonIterator(target:SimpleButton)
		{
			addItems(target.overState);
			addItems(target.upState);
			addItems(target.overState);
		}

		private function addItems(state:DisplayObject):void
		{
			_items.push(state);

			if (_items is DisplayObjectContainer)
				fromDisplayTree(DisplayObjectContainer(state)).apply(_items.push);
		}

		override flash_proxy function nextNameIndex(index:int):int
		{
			return _index < _items.length ? 1 : 0;
		}

		override flash_proxy function nextValue(index:int):*
		{
			return _items.getChildAt(_index++);
		}
	}
}
