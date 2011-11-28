package actionlib.motion.filter
{
	import actionlib.motion.motion_internal;

	import flash.filters.BitmapFilter;

	use namespace motion_internal;

	public class FilterTween
	{
		public static function to(parameters:Object):FilterTween
		{
			return new FilterTween(0).to(parameters);
		}

		public static function byClass(classRef:Class):FilterTween
		{
			return new FilterTween(classRef);
		}

		public static function byInstance(filter:BitmapFilter):FilterTween
		{
			return new FilterTween(filter);
		}

		public static function byNum(num:int = 0):FilterTween
		{
			return new FilterTween(num);
		}

		public function FilterTween(filterID:Object)
		{
			this.filterId = filterID;
		}

		public function to(parameters:Object):FilterTween
		{
			this._endValues = parameters;
			return this;
		}

		public function autoRemove():FilterTween
		{
			isAutoRemove = true;
			return this;
		}

		motion_internal var filterId:Object = 0;
		motion_internal var isAutoRemove:Boolean = false;
		motion_internal var filter:BitmapFilter;

		private var _endValues:Object = {};
		private var _startValues:Object = {};

		motion_internal function initialize(filter:BitmapFilter):void
		{
			this.filter = filter;
			initStartValues();
		}

		private function initStartValues():void
		{
			for (var propName:String in _endValues)
			{
				_startValues[propName] = filter[propName];
			}
		}

		motion_internal function applyTween(relativeTime:Number):void
		{
			for (var propName:String in _endValues)
			{
				var startValue:Number = _startValues[propName];
				var endValue:Number = _endValues[propName];
				filter[propName] = startValue + relativeTime * (endValue - startValue);
			}
		}

		motion_internal function applyComplete():void
		{
			for (var propName:String in _endValues)
			{
				filter[propName] = _endValues[propName];
			}
		}
	}
}
