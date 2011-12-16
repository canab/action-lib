package actionlib.common.logging.adapters
{
	import actionlib.common.logging.ILogAdapter;

	public class TraceLogAdapter implements ILogAdapter
	{
		public function print(sender:Object, level:int, message:String):void
		{
			trace(message);
		}
	}
}
