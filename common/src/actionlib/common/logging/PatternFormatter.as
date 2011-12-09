package actionlib.common.logging
{
	public class PatternFormatter implements ILogFormatter
	{
		public static const DEFAULT_PATTERN:String = "{level}: [{sender}] - {message}";

		private var _pattern:String;

		public function PatternFormatter(pattern:String = null)
		{
			_pattern = pattern || DEFAULT_PATTERN;
		}

		public function format(sender:String, level:String, message:String):String
		{
			var levelText:String = (level.length == 4 ? " " : "") + level;

			return _pattern
					.replace("{level}", levelText)
					.replace("{sender}", sender)
					.replace("{message}", message);
		}
	}
}
