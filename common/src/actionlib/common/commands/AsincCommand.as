package actionlib.common.commands
{
	import actionlib.common.events.EventSender;

	public class AsincCommand implements IAsincCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);

		public function AsincCommand()
		{
		}

		public function onComplete(handler:Function):AsincCommand
		{
			_completeEvent.addListener(handler);
			return this;
		}

		protected function dispatchComplete():void
		{
			_completeEvent.dispatch();
		}

		public virtual function execute():void
		{
		}

		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
	}
}
