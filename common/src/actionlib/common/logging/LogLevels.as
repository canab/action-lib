package actionlib.common.logging
{
	import actionlib.common.errors.ItemNotFoundError;

	public class LogLevels
	{
		public static const DEBUG:int = 0;
		public static const INFO:int = 1;
		public static const WARN:int = 2;
		public static const ERROR:int = 3;

		private static var _levelNames:Array = ["debug", "info", "warn", "error"];

		public static function getName(level:int):String
		{
			var levelName:String = _levelNames[level];

			if (!levelName)
				throw new ItemNotFoundError();

			return levelName;
		}

		public static function getLevel(name:String):int
		{
			var levelNum:int = _levelNames.indexOf(name);

			if (levelNum == -1)
				throw new ItemNotFoundError();

			return levelNum;
		}
	}
}
