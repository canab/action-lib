package actionlib.gui
{
	import actionlib.common.events.EventSender;

	public class UIEvents
	{
		private var _windowAdded:EventSender = new EventSender(this);
		private var _windowRemoved:EventSender = new EventSender(this);
		private var _screenChanged:EventSender = new EventSender(this);

		public function get windowAdded():EventSender
		{
			return _windowAdded;
		}

		public function get windowRemoved():EventSender
		{
			return _windowRemoved;
		}

		public function get screenChanged():EventSender
		{
			return _screenChanged;
		}
	}
}
