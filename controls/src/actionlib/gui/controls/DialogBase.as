package actionlib.gui.controls
{
	import actionlib.common.commands.CallLaterCommand;
	import actionlib.gui.UI;

	import flash.events.Event;

	public class DialogBase extends WindowBase
	{
		private var _timeout:int = 0;

		public function DialogBase()
		{
		}

		public function onClose(handler:Function):DialogBase
		{
			closeEvent.addListener(handler);
			return this;
		}

		public function show():void
		{
			UI.showDialog(this);
		}

		protected function doDefaultAction():void
		{
			closeWindow();
		}

		public function setTimeout(value:int):void
		{
			if (value <= 0 || _timeout > 0)
				return;

			_timeout = value;

			if (stage)
				initTimeout();
			else
				addEventListener(Event.ADDED_TO_STAGE, initTimeout);
		}

		private function initTimeout(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initTimeout);
			new CallLaterCommand(onTimeout, _timeout).execute();
		}

		private function onTimeout():void
		{
			if (stage)
				doDefaultAction();
		}
	}
}
