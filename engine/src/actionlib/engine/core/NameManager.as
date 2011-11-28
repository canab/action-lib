package actionlib.engine.core
{
	internal class NameManager
	{
		public static const SEPARATOR:String = "@";
		public static const PREFIX:String = "_";

		private var _currentNum:uint = 0;

		public function getUniqueName():String
		{
			return PREFIX + String(_currentNum++);
		}
	}
}
