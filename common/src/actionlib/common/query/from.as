package actionlib.common.query
{
	import actionlib.common.errors.NullParameterError;

	public function from(collection:Object):Query
	{
		if (!collection)
			throw new NullParameterError();

		return new Query(collection);
	}
}
