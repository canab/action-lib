package actionlib.engine.core
{
	internal class DelayedProcessor extends ProcessorBase
	{
		private var _frameCount:int;
		private var _method:Function;

		function DelayedProcessor(method:Function, frameCount:int)
		{
			_method = method;
			_frameCount = frameCount;

			super(delayFunc);
		}

		private function delayFunc():void
		{
			if (--_frameCount == 0)
			{
				_method();
				disposed = true;
			}
		}
	}
}
