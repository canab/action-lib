package actionlib.common.logging.formatters
{
	import actionlib.common.logging.ILogFormatter;

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

		public function get pattern():String
		{
			return _pattern;
		}

		public function set pattern(value:String):void
		{
			_pattern = value;
		}
	}
}
