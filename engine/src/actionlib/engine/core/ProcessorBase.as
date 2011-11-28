package actionlib.engine.core
{
	internal class ProcessorBase
	{
		internal var next:ProcessorBase;
		internal var prev:ProcessorBase;

		internal var component:Component;
		internal var method:Function;
		internal var args:Array;
		
		internal var disposed:Boolean = false;

		internal virtual function process():void
		{
		}

		internal function get isActive():Boolean
		{
			if (disposed)
				return false;

			if (!component)
				return true;

			return !component.disposed;
		}
	}
}
