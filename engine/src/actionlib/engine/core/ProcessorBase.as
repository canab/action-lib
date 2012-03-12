package actionlib.engine.core
{

	internal class ProcessorBase
	{
		internal var next:ProcessorBase;
		internal var prev:ProcessorBase;

		internal var process:Function;
		internal var disposed:Boolean = false;

		public function ProcessorBase(processFunc:Function)
		{
			process = processFunc;
		}
	}
}
