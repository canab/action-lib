package actionlib.motion.filter
{
	import actionlib.motion.motion_internal;
	import actionlib.motion.properties.ITweenProperty;

	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;

	use namespace motion_internal;

	public class FilterProperty implements ITweenProperty
	{
		private static const INVALID_PARAMETER:String = "Parameter's type should be either of FilterTween or Array of FilterTween";
		private static const FILTER_NOT_SPECIFIED:String = "Filter is not specified";
		private static const INVALID_INDEX:String = "Cannot get filter by provided index";

		private var _target:DisplayObject;
		private var _filters:Array;
		private var _tweens:Array = [];

		public function initialize(target:Object, endValue:Object):void
		{
			_target = DisplayObject(target);
			_filters = _target.filters;

			if (endValue is FilterTween)
				initTween(endValue as FilterTween);
			else if (endValue is Array)
				initTweens(endValue as Array);
			else
				throw new ArgumentError(INVALID_PARAMETER);
		}

		private function initTweens(array:Array):void
		{
			for each (var filterTween:FilterTween in array)
			{
				initTween(filterTween);
			}
		}

		private function initTween(tween:FilterTween):void
		{
			var filter:BitmapFilter = getFilter(tween.filterId);
			
			if (_filters.indexOf(filter) == -1)
				_filters.push(filter);

			tween.initialize(filter);

			_tweens.push(tween);
		}

		private function getFilter(filterId:Object):BitmapFilter
		{
			if (filterId is int)
				return getFilterByIndex(int(filterId));
			else if (filterId is Class)
				return getFilterByClass(Class(filterId));
			else if (filterId is BitmapFilter)
				return BitmapFilter(filterId);
			else
				throw new ArgumentError(FILTER_NOT_SPECIFIED);
		}

		private function getFilterByIndex(index:int):BitmapFilter
		{
			if (index < _filters.length)
				return _filters[index];
			else
				throw new ArgumentError(INVALID_INDEX);
		}

		private function getFilterByClass(classRef:Class):BitmapFilter
		{
			for each (var filter:BitmapFilter in _filters)
			{
				if (filter is classRef)
					return filter;
			}

			return new classRef();
		}


		public function applyTween(relativeTime:Number):void
		{
			for each (var tween:FilterTween in _tweens)
			{
				tween.applyTween(relativeTime);
			}

			_target.filters = _filters;
		}

		public function applyComplete():void
		{
			for each (var tween:FilterTween in _tweens)
			{
				tween.applyComplete();

				if (tween.isAutoRemove)
					removeFilter(tween.filter);
			}

			_target.filters = _filters;
		}

		private function removeFilter(filter:BitmapFilter):void
		{
			var index:int = _filters.indexOf(filter);
			if (index >= 0)
				_filters.splice(index, 1);
		}
	}
}
