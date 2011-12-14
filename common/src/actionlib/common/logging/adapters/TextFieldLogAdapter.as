package actionlib.common.logging.adapters
{
	import actionlib.common.logging.ILogAdapter;
	import actionlib.common.logging.LogLevels;

	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextFieldLogAdapter implements ILogAdapter
	{
		private var _field:TextField;
		private var _formats:Object = {};

		public function TextFieldLogAdapter(field:TextField)
		{
			_field = field;

			_formats[LogLevels.INFO] = _field.getTextFormat();
			_formats[LogLevels.DEBUG] = _field.getTextFormat();
			_formats[LogLevels.WARN] = _field.getTextFormat();
			_formats[LogLevels.ERROR] = _field.getTextFormat();

			setColors();
		}

		public function setColors(
				debugColor:uint = 0xAAAAAA,
				infoColor:uint = 0x222222,
				warnColor:uint = 0xD56A00,
				errorColor:uint = 0xAA0000):void
		{
			TextFormat(_formats[LogLevels.DEBUG]).color = debugColor;
			TextFormat(_formats[LogLevels.INFO]).color = infoColor;
			TextFormat(_formats[LogLevels.WARN]).color = warnColor;
			TextFormat(_formats[LogLevels.ERROR]).color = errorColor;
		}

		public function print(sender:Object, level:int, message:String):void
		{
			if (_field.text.length > 0)
				_field.appendText("\n");

			_field.appendText(message);
			_field.setTextFormat(_formats[level], _field.text.length - message.length - 1, _field.text.length);
			_field.scrollV = _field.maxScrollV;
		}
	}
}
