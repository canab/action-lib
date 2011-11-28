package actionlib.common.query
{
	import actionlib.common.errors.NullParameterError;
	import actionlib.common.query.iterators.DisplayIterator;

	import flash.display.DisplayObjectContainer;

	public function fromDisplay(target:DisplayObjectContainer):Query
	{
		if (!target)
			throw new NullParameterError();

		return new Query(new DisplayIterator(target));
	}
}
