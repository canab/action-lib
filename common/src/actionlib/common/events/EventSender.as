package actionlib.common.events
{
	import actionlib.common.errors.NullPointerError;

	public class EventSender
	{
		private var _sender:Object;
		private var _listeners:Vector.<Function>;
		private var _listenersCopy:Vector.<Function>;
		private var _listenersCopyValid:Boolean = false;

		public function EventSender(sender:Object)
		{
			_sender = sender;
			_listeners = new Vector.<Function>();
		}
		
		public function addListener(listener:Function):void
		{
			if (listener == null)
				throw new NullPointerError();
			else if (hasListener(listener))
				throw new Error("List already contains such listener");
			else
				_listeners.push(listener);

			_listenersCopyValid = false;
		}
		
		public function removeListener(listener:Function):void
		{
			if (listener == null)
				throw new NullPointerError();
			else if (hasListener(listener))
				_listeners.splice(_listeners.indexOf(listener), 1);
			else
				throw new Error("List doesn't contain such listener");

			_listenersCopyValid = false;
		}
		
		public function dispatch(argument:* = null):void
		{
			if (!_listenersCopyValid)
			{
				_listenersCopy = _listeners.slice();
				_listenersCopyValid = true;
			}

			for each (var handler:Function in _listenersCopy)
			{
				if (handler.length == 0)
					handler();
				else if (handler.length == 1)
					handler(_sender);
				else if (handler.length == 2)
					handler(_sender, argument);
				else
					throw new ArgumentError();
			}
		}

		public function hasListener(func:Function):Boolean
		{
			return _listeners.indexOf(func) >= 0;
		}

		public function set handler(value:Function):void
		{
			addListener(value);
		}
	}
}