package actionlib.common.commands
{
	public class AsincWrapper extends AsincCommand
	{
		private var _func:Function;

		public function AsincWrapper(func:Function)
		{
			_func = func;
		}

		override public virtual function execute():void
		{
			_func();
			dispatchCompleteAsync();
		}
	}
}
