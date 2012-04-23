package actionlib.engine.components
{
	import actionlib.engine.core.Component;

	public class TickCounter extends Component
	{
		private var _currentTick:uint = 0;

		public function TickCounter()
		{
			addFrameListener(onEnterFrame);
		}

		private function onEnterFrame():void
		{
			_currentTick++;
		}

		public function get currentTick():uint
		{
			return _currentTick;
		}
	}
}
