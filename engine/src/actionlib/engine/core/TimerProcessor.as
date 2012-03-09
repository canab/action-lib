package actionlib.engine.core
{
	internal class TimerProcessor extends ProcessorBase
	{
		private var _frameNum:int = 0;
		private var _frameCount:int;
		private var _method:Function;

		function TimerProcessor(method:Function, frameCount:int)
		{
			_method = method;
			_frameCount = frameCount;

			super(timerFunc);
		}

		private function timerFunc():void
		{
			if (++_frameNum == _frameCount)
			{
				_method();
				_frameNum = 0;
			}
		}
	}
}
