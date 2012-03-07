package actionlib.engine.core
{
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.utils.ReflectUtil;

	public class Component
	{
		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		
		public var engine:Engine;
		public var parent:Entity;
		public var name:String;
		
		public function Component() 
		{
			super();
		}
		
		internal function initialize():void
		{
			if (initialized)
				throw new AlreadyInitializedError();
			
			if (!name)
				name = ReflectUtil.getClassName(this) + engine.nameManager.getUniqueName();

			initialized = true;
			
			onInitialize();
		}
		
		internal function dispose():void 
		{
			if (!initialized)
				throw new NotInitializedError();
			
			if (disposed)
				throw new AlreadyDisposedError();
				
			disposed = true;
				
			onDispose();
		}

		public function get fullName():String
		{
			return (parent)
				? parent.name + NameManager.SEPARATOR + name
				: name;
		}

		public function get isInitialized():Boolean
		{
			return initialized;
		}
		
		public function get isDisposed():Boolean
		{
			return disposed;
		}

		protected virtual function onInitialize():void
		{
		}
		
		protected virtual function onDispose():void
		{
		}
		
		/**
		 * Call method on enter frame
		 */
		protected function addFrameListener(method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.addFrameListener(this, method);
		}

		/**
		 * Call method after given time
		 * @param	time
		 * time in milliseconds
		 */
		protected function addDelayedCall(time:int, method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.addDelayedCall(time, this, method);
		}

		/**
		 * Call method periodically
		 * @param	time
		 * time in milliseconds
		 */
		protected function addTimer(time:int, method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.addTimer(time, this, method);
		}

		/**
		 * Remove previously added timer, delayedCall or frameListener
		 * Returns true if processor was existing
		 */
		protected function removeProcessor(method:Function):Boolean
		{
			return engine.removeProcessor(this, method);
		}

		protected function hasProcessor(method:Function):Boolean
		{
			return engine.hasProcessor(this, method);
		}

		public function removeSelf():void
		{
			parent.removeComponent(this);
		}

		public function toString():String
		{
			return ReflectUtil.getClassName(this) + "[" + fullName + "]";
		}
	}

}