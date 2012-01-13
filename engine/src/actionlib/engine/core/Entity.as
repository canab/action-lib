package actionlib.engine.core
{
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.ItemNotFoundError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.events.EventSender;

	public class Entity
	{
		public var name:String;
		
		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		internal var engine:Engine;

		private var _components:Vector.<Component>;
		private var _disposeEvent:EventSender;

		public function Entity() 
		{
			_components = new Vector.<Component>();
		}
		
		internal function initialize():void
		{
			if (initialized)
				throw new AlreadyInitializedError();
			
			for each (var component:Component in _components)
			{
				initializeComponent(component);
			}
			
			initialized = true;
		}
		
		internal function dispose():void
		{
			if (!initialized)
				throw new NotInitializedError();
			
			if (disposed)
				throw new AlreadyDisposedError();
			
			for each (var component:Component in _components) 
			{
				component.dispose();
			}
			
			disposed = true;

			if (_disposeEvent)
				_disposeEvent.dispatch();
		}

		public function addComponents(componentsCollection:Object):void
		{
			for each (var component:Component in componentsCollection)
			{
				addComponent(component);
			}
		}

		public function addComponent(component:Component):void
		{
			if (disposed)
				throw new Error("Entity is disposed");

			_components.push(component);

			if (initialized)
				initializeComponent(component);
		}
		
		private function initializeComponent(component:Component):void 
		{
			component.engine = engine;
			component.parent = this;
			component.initialize();
		}
		
		public function removeComponent(component:Component):void 
		{
			if (disposed)
				throw new AlreadyDisposedError();
				
			component.dispose();
			
			var index:int = _components.indexOf(component);
			if (index == -1)
				throw new ItemNotFoundError();
			else
				_components.splice(index, 1);
		}
		
		public function getComponentByType(type:Class):Component
		{
			for each (var item:Component in _components)
			{
				if (item is type)
					return item;
			}
			return null;
		}

		public function removeComponentByType(type:Class):void
		{
			var component:Component = getComponentByType(type);
			if (component)
				removeComponent(component);
		}

		public function getComponentsByType(type:Class):Vector.<Component>
		{
			var result:Vector.<Component> = new <Component>[];
			for each (var item:Component in _components)
			{
				if (item is type)
					result.push(item);
			}
			return result;
		}

		public function getComponentByName(name:String):Component
		{
			for each (var item:Component in _components) 
			{
				if (item.name == name)
					return item;
			}
			return null;
		}

		public function get disposeEvent():EventSender
		{
			if (!_disposeEvent)
				_disposeEvent = new EventSender(this);

			return _disposeEvent;
		}
	}

}