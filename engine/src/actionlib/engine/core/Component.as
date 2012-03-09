package actionlib.engine.core
{
	public class Component extends ComponentGroup
	{
		private var _activity:ComponentActivity;

		override internal function initialize():void
		{
			super.initialize();

			if (_activity)
				_activity.initialize(engine);

			onInitialize();
		}

		override internal function dispose():void
		{
			super.dispose();

			if (_activity)
				_activity.dispose();

			onDispose();
		}

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
			return activity.hasProcessor(method);
		}


		//-- virtual --//


		protected function onInitialize():void { }

		protected function onDispose():void { }


		//-- get/set --//


		private function get activity():ComponentActivity
		{
			if (!_activity)
				_activity = new ComponentActivity(engine);

			return _activity;
		}
	}

}