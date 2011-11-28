package actionlib.common.localization
{
	import actionlib.common.events.EventSender;

	public class MessageBundle
	{
		private var _readyEvent:EventSender = new EventSender(this);
		private var _changeEvent:EventSender = new EventSender(this);

		private var _id:String;
		private var _messages:Object;
		private var _isReady:Boolean = false;

		public function MessageBundle(id:String)
		{
			_id = id;
		}

		public function hasMessageId(messageId:String):Boolean
		{
			return (messageId in _messages);
		}

		public function getMessage(messageId:String):String
		{
			return messages[messageId];
		}

		public function getLocalizedText(text:String):String
		{
			// find tokens enclosed by curly braces
			var tokens:Array = text.match(/{[^}]+}/g);
			var locText:String = text;

			for each (var token:String in tokens)
			{
				var messageId:String = token.substr(1, token.length - 2);
				var message:String = getMessage(messageId);

				locText = locText.replace(token, message || token);
			}

			return locText;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		internal function get id():String
		{
			return _id;
		}

		internal function get messages():Object
		{
			return _messages;
		}

		internal function set messages(value:Object):void
		{
			_messages = value;

			if (!_isReady)
			{
				_isReady = true;
				_readyEvent.dispatch();
			}

			_changeEvent.dispatch();
		}

		public function get changeEvent():EventSender
		{
			return _changeEvent;
		}

		public function get readyEvent():EventSender
		{
			return _readyEvent;
		}
	}

}