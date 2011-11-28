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
			if (condition == null)
				throw new NullParameterError();

			_condition = condition;

			return this;
		}

		public function map(mapper:Function):Query
		{
			if (mapper == null)
				throw new NullParameterError();

			_mapper = mapper;

			return this;
		}

		public function exists():Boolean
		{
			return findFirst() != undefined;
		}

		public function findFirst(mapper:Function = null):*
		{
			if (mapper != null)
				_mapper = mapper;

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
			if (mapper != null)
				_mapper = mapper;

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

			for each (var item:* in _collection)
			{
				if (_condition(item))
					result = aggregator(result, _mapper(item));
			}

			return result;
		}
	}
}
