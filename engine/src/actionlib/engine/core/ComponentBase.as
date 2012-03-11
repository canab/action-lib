package actionlib.engine.core
{
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.ReflectUtil;

	public class ComponentBase
	{
		public static const PATH_SEPARATOR:String = "/";

		public var name:String;
		public var engine:Engine;
		public var parent:ComponentGroup;

		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		internal var prev:ComponentBase;
		internal var next:ComponentBase;

		private var _disposeEvent:EventSender;

		internal function initialize(engine:Engine):void
		{
			if (initialized)
				throw new AlreadyInitializedError();

			if (!name)
				name = engine.nameManager.getUniqueName(ReflectUtil.getClassName(this));

			this.engine = engine;
			initialized = true;
		}

		internal function dispose():void
		{
			if (!initialized)
				throw new NotInitializedError();
			
			if (disposed)
				throw new AlreadyDisposedError();

			engine = null;
			disposed = true;

			if (_disposeEvent)
				_disposeEvent.dispatch();
		}

		public function removeSelf():void
		{
			parent.removeComponent(this);
		}

		public function getPath():String
		{
			assertInitialized();
			var path:String = name;

			for (var comp:ComponentBase = parent; comp != engine; comp = comp.parent)
			{
				path = comp.name + PATH_SEPARATOR + path;
			}

			return path;
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

		public function get disposeEvent():EventSender
		{
			if (!_disposeEvent)
				_disposeEvent = new EventSender(this);

			return _disposeEvent;
		}

	}

}