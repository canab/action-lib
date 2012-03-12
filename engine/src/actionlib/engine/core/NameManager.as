package actionlib.engine.core
{
	internal class NameManager
	{
		private var _prefixes:Object = {};

		public function getUniqueName(prefix:String = "#"):String
		{
			var num:int = _prefixes[prefix];
			num++;
			_prefixes[prefix] = num;

			return prefix + num;
		}
	}
}
