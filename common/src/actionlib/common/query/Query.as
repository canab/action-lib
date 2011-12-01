package actionlib.common.query
{
	import actionlib.common.errors.NullParameterError;

	public class Query
	{
		//noinspection JSUnusedLocalSymbols
		private static function trueCondition(item:*):Boolean
		{
			return true;
		}

		private static function selfMapper(item:*):*
		{
			return item;
		}

		private var _collection:Object;
		private var _condition:Function = trueCondition;
		private var _mapper:Function = selfMapper;

		public function Query(collection:Object)
		{
			if (collection == null)
				throw new NullParameterError();

			_collection = collection;
		}

		public function where(condition:Function):Query
		{
			_condition = condition || trueCondition;
			return this;
		}

		public function map(mapper:Function):Query
		{
			_mapper = mapper || selfMapper;
			return this;
		}

		public function exists():Boolean
		{
			return findFirst() != undefined;
		}

		public function findFirst(mapper:Function = null):*
		{
			map(mapper);

			for each (var item:* in _collection)
			{
				if (_condition(item))
					return _mapper(item);
			}

			return undefined;
		}

		public function apply(func:Function):void
		{
			for each (var item:* in _collection)
			{
				if (_condition(item))
					func(_mapper(item));
			}
		}

		public function select(mapper:Function = null):Array
		{
			map(mapper);

			var result:Array = [];

			for each (var item:* in _collection)
			{
				if (_condition(item))
					result.push(_mapper(item));
			}

			return result;
		}

		public function aggregate(aggregator:Function):*
		{
			if (aggregator == null)
				throw new NullParameterError();

			var result:* = undefined;
			var isFirstItem:Boolean = true;

			for each (var item:* in _collection)
			{
				if (!_condition(item))
					continue;

				if (isFirstItem)
				{
					result = _mapper(item);
					isFirstItem = false;
				}
				else
				{
					result = aggregator(result, _mapper(item));
				}
			}

			return result;
		}
	}
}
