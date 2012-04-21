package actionlib.common.ui
{
	import actionlib.common.utils.StringUtil;

	import flash.events.KeyboardEvent;

	public class KeyStroke
	{
		/**
		 *
		 * @param text
		 * example: "Ctrl+Alt+A", "Shift+B"
		 * @see actionlib.common.ui.Key
		 */
		public static function parse(text:String):KeyStroke
		{
			if (!text)
				return null;

			var parts:Array = text.split("+");

			if (parts.length == 0)
				return null;

			var keyName:String = StringUtil.trim(parts.pop());
			var key:Key = Key.getByName(keyName);

			if (!key)
				return null;

			var keyStroke:KeyStroke = new KeyStroke(key);

			for each (var part:String in parts)
			{
				var firstChar:String = StringUtil.trim(part).charAt(0).toUpperCase();
				if (firstChar == "C")
					keyStroke.isControl = true;
				else if (firstChar == "A")
					keyStroke.isAlt = true;
				else if (firstChar == "S")
					keyStroke.isShift = true;
			}

			return keyStroke;
		}

		public var key:Key;
		public var isControl:Boolean;
		public var isShift:Boolean;
		public var isAlt:Boolean;

		public function KeyStroke(key:Key)
		{
			this.key = key;
		}

		public function acceptsEvent(e:KeyboardEvent):Boolean
		{
			return key.code == e.keyCode
					&& isControl == e.ctrlKey
					&& isAlt == e.altKey
					&& isShift == e.shiftKey;
		}

		public function getText():String
		{
			var parts:Array = [];

			if (isControl)
				parts.push(Key.CONTROL.name);

			if (isAlt)
				parts.push(Key.ALTERNATE.name);

			if (isShift)
				parts.push(Key.SHIFT.name);

			parts.push(key.name);

			return parts.join("+");
		}
	}
}
