package actionlib.engine.core
{
	internal class FrameProcessor extends ProcessorBase
	{
		override internal virtual function process():void
		{
			method.apply(null, args);
		}
	}
}
