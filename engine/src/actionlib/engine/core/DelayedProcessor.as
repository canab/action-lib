package actionlib.engine.core
{
	internal class DelayedProcessor extends ProcessorBase
	{
		public var frameCount:int;

		override internal virtual function process():void
		{
			if (--frameCount == 0)
			{
				method.apply(null, args);
				disposed = true;
			}
		}
	}
}
