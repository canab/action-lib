package actionlib.engine.core
{
	import actionlib.common.commands.CallFunctionCommand;
	import actionlib.common.commands.ICommand;
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.ItemNotFoundError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.events.EventSender;

	public class Entity
	{
		public static function fromComponents(...args):Entity
		{
			var entity:Entity = new Entity();

			for each (var component:Component in args)
			{
				entity.addComponent(component);
			}

			return entity;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public var name:String;
		
		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		internal var engine:Engine;

		private var _components:Vector.<Component>;
		private var _disposeEvent:EventSender;
		private var _postProcessingCommands:Array = [];
		private var _processingState:Boolean;

		public function Entity() 
		{
			_components = new Vector.<Component>();
		}

		internal function initialize():void
		{
			if (initialized)
				throw new AlreadyInitializedError();

			_processingState = true;

			for each (var component:Component in _components)
			{
				initializeComponent(component);
			}

			_processingState = false;

			initialized = true;

			processPostCommands();
		}


		internal function dispose():void
		{
			if (!initialized)
				throw new NotInitializedError();

			if (disposed)
				throw new AlreadyDisposedError();

			_processingState = true;

			for each (var component:Component in _components)
			{
				component.dispose();
			}

			_processingState = false;

			processPostCommands();

			disposed = true;

			if (_disposeEvent)
				_disposeEvent.dispatch();
		}

		private function processPostCommands():void
		{
			for each (var command:ICommand in _postProcessingCommands)
			{
				command.execute();
			}
			_postProcessingCommands.length = 0;
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
			if (_processingState)
			{
				_postProcessingCommands.push(new CallFunctionCommand(addComponent, arguments));
				return;
			}

			if (disposed)
				throw new Error("Entity is disposed");

			_components.push(component);

			component.parent = this;

			if (initialized)
				initializeComponent(component);
		}
		
		private function initializeComponent(component:Component):void 
		{
			component.engine = engine;
			component.initialize();
		}
		
		public function removeComponent(component:Component):void 
		{
			if (_processingState)
			{
				_postProcessingCommands.push(new CallFunctionCommand(removeComponent, arguments));
				return;
			}

			if (disposed)
				throw new AlreadyDisposedError();
				
			component.dispose();
			component.parent = null;
			component.engine = null;
			
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

		public function removeComponentByName(name:String):void
		{
			var component:Component = getComponentByName(name);
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

		public function toString():String
		{
			return "Entity[" + name + "]";
		}
	}

}