package actionlib.common.query.iterators
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObjectContainer;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;

	public class DisplayTreeIterator extends Proxy
	{
		//noinspection JSFieldCanBeLocal
		private var _stack:Array = [];
		private var _target:DisplayObjectContainer;
		private var _currentTarget:DisplayObjectContainer;
		private var _currentCount:int;
		private var _currentNum:int;

		public function DisplayTreeIterator(target:DisplayObjectContainer)
		{
			_target = target;
		}

		override flash_proxy function nextNameIndex(index:int):int
		{
			if (!_currentTarget)
			{
				_currentTarget = _target;
				_currentCount = _currentTarget.numChildren;
				_currentNum = 0;
			}

			return _currentNum < _currentCount ? 1 : 0;
		}

		override flash_proxy function nextValue(index:int):*
		{
			var result:DisplayObject = _currentTarget.getChildAt(_currentNum++);

			if (result is DisplayObjectContainer && DisplayObjectContainer(result).numChildren > 0)
				_stack.push(result);

			if (_currentNum == _currentCount && _stack.length > 0)
			{
				_currentTarget = _stack.pop();
				_currentCount = _currentTarget.numChildren;
				_currentNum = 0;
			}

			return result;
		}
	}
}
