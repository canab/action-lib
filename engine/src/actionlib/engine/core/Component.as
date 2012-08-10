package actionlib.engine.core
{
	public class Component extends GroupBase
	{
		private var _activity:ComponentActivity;

		override internal function initialize(engine:Engine):void
		{
			super.initialize(engine);

			if (_activity)
				_activity.initialize(engine);

			onInitialize();
		}

		override internal function dispose():void
		{
			onDispose();

			if (_activity)
				_activity.dispose();

			super.dispose();
		}

		//-- virtual --//


		protected function onInitialize():void { }

		protected function onDispose():void { }


		//-- processors --//


		protected function addFrameListener(method:Function):void
		{
			assertNotDisposed();
			activity.addFrameListener(method);
		}

		protected function addDelayedCall(milliseconds:int, method:Function):void
		{
			assertNotDisposed();
			activity.addDelayedCall(milliseconds, method);
		}

		protected function addTimer(milliseconds:int, method:Function):void
		{
			assertNotDisposed();
			activity.addTimer(milliseconds, method);
		}

		/**
		 * Remove previously added timer, delayedCall or frameListener
		 */
		protected function removeProcessor(method:Function):void
		{
			assertNotDisposed();
			activity.removeProcessor(method);
		}

		protected function hasProcessor(method:Function):Boolean
		{
			return (_activity != null && _activity.hasProcessor(method));
		}


		//-- get/set --//


		private function get activity():ComponentActivity
		{
			if (!_activity)
				_activity = new ComponentActivity(engine);

			return _activity;
		}
	}

}