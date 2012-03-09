package actionlib.engine.core
{
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.utils.ReflectUtil;

	public class ComponentBase
	{
		public var name:String;
		public var engine:Engine;
		public var parent:ComponentGroup;

		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		internal var prev:ComponentBase;
		internal var next:ComponentBase;

		internal function initialize():void
		{
			if (initialized)
				throw new AlreadyInitializedError();
			
			if (!name)
				name = engine.nameManager.getUniqueName(ReflectUtil.getClassName(this));

			initialized = true;
		}

		internal function dispose():void
		{
			if (!initialized)
				throw new NotInitializedError();
			
			if (disposed)
				throw new AlreadyDisposedError();
				
			disposed = true;
		}

		public function removeSelf():void
		{
			parent.removeComponent(this);
		}


		//-- asserts --//


		internal function assertInitialized():void
		{
			if (!initialized)
				throw new NotInitializedError();
		}

		internal function assertNotDisposed():void
		{
			if (disposed)
				throw new AlreadyDisposedError();
		}

		internal function assertIsReady():void
		{
			if (!initialized)
				throw new NotInitializedError();

			if (disposed)
				throw new AlreadyDisposedError();
		}


		//-- get/set --//


		public function toString():String
		{
			return ReflectUtil.getClassName(this) + "[" + name + "]";
		}

		public function get isInitialized():Boolean
		{
			return initialized;
		}
		
		public function get isDisposed():Boolean
		{
			return disposed;
		}

	}

}