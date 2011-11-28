package actionlib.engine.core
{
	internal class TimerProcessor extends ProcessorBase
	{
		public var frameNum:int = 0;
		public var frameCount:int;

		override internal virtual function process():void
		{
			if (++frameNum == frameCount)
			{
				method.apply(null, args);
				frameNum = 0;
			}
		}
	}
}
