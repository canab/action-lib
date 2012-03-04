package actionlib.engine.core
{
	import actionlib.common.display.StageReference;
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.ItemAlreadyExistsError;
	import actionlib.common.errors.ItemNotFoundError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.events.EventSender;
	import actionlib.common.logging.Logger;
	import actionlib.motion.TweenManager;
	import actionlib.motion.Tweener;

	public class Engine
	{
		internal var nameManager:NameManager = new NameManager();

		private var _logger:Logger = new Logger(this);

		private var _startEvent:EventSender = new EventSender(this);
		private var _stopEvent:EventSender = new EventSender(this);

		private var _processManager:ProcessManager;
		private var _tweenManager:TweenManager;
		private var _entities:Object = {};
		private var _started:Boolean;
		private var _initialized:Boolean = false;
		private var _disposed:Boolean = false;
		private var _context:Object;

		public function Engine()
		{
			_processManager = new ProcessManager();
			_tweenManager = new TweenManager();
		}

		public function dispose():void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			stop();

			for each (var entity:Entity in _entities)
			{
				entity.dispose();
			}

			_disposed = true;
			_logger.debug("disposed");
		}

		public function addEntity(entity:Entity):void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (entityExists(entity.name))
				throw new ItemAlreadyExistsError();

			if (!entity.name)
				entity.name = nameManager.getUniqueName();

			_entities[entity.name] = entity;

			entity.engine = this;

			if (_initialized)
				entity.initialize();
		}

		public function removeEntity(entity:Entity):void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (!entityExists(entity.name))
				throw new ItemNotFoundError();

			if (_initialized)
				entity.dispose();

			delete _entities[entity.name];
		}

		public function start():void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (_started)
				return;

			if (!_initialized)
				initialize();

			_started = true;
			_processManager.start();
			_tweenManager.resumeAll();
			_logger.debug("started");
			_startEvent.dispatch();
		}

		public function doStepsForce(stepsCount:int = 1):void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (!_initialized)
				throw new NotInitializedError();

			for (var i:int = 0; i < stepsCount; i++)
			{
				_processManager.onEnterFrame(null);
			}
		}

		public function stop():void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (!_started)
				return;

			_started = false;
			_processManager.stop();
			_tweenManager.pauseAll();
			_logger.debug("stopped");
			_stopEvent.dispatch();
		}

		private function initialize():void
		{
			for each (var entity:Entity in _entities)
			{
				entity.initialize();
			}

			_initialized = true;
		}

		public function tween(target:Object, duration:Number = -1):Tweener
		{
			return _tweenManager.tween(target, duration);
		}

		internal function addFrameListener(component:Component, method:Function):void
		{
			var processor:FrameProcessor = new FrameProcessor();
			processor.component = component;
			processor.method = method;

			_processManager.addProcessor(processor);
		}

		/**
		 * Call method after given time
		 * @param	time
		 * time in milliseconds
		 */
		internal function addDelayedCall(time:int, component:Component, method:Function):void
		{
			var processor:DelayedProcessor = new DelayedProcessor();
			processor.component = component;
			processor.method = method;
			processor.frameCount = Math.max(time / 1000.0 * frameRate, 1);

			_processManager.addProcessor(processor);
		}

		/**
		 * Call method periodically
		 * @param	time
		 * time in milliseconds
		 */
		internal function addTimer(time:int, component:Component, method:Function):void
		{
			var processor:TimerProcessor = new TimerProcessor();
			processor.component = component;
			processor.method = method;
			processor.frameCount = Math.max(time / 1000.0 * frameRate, 1);

			_processManager.addProcessor(processor);
		}

		/**
		 * Remove previously added timer, delayedCall or frameListener
		 */
		internal function removeProcessor(component:Component, method:Function):Boolean
		{
			var processor:ProcessorBase = _processManager.findProcessor(component, method);

			if (processor)
				_processManager.removeProcessor(processor);

			return Boolean(processor);
		}

		public function hasProcessor(component:Component, method:Function):Boolean
		{
			return Boolean(_processManager.findProcessor(component, method));
		}

		public function getEntitiesByType(type:Class):Array
		{
			var result:Array = [];
			for each (var item:Entity in _entities)
			{
				if (item is type)
					result.push(item);
			}
			return result;
		}

		public function getEntityByType(type:Class):Entity
		{
			for each (var item:Entity in _entities)
			{
				if (item is type)
					return item;
			}
			return null;
		}

		public function getEntityByName(name:String):Entity
		{
			for each (var item:Entity in _entities)
			{
				if (item.name == name)
					return item;
			}
			return null;
		}

		public function removeEntityByType(type:Class):void
		{
			var entity:Entity = getEntityByType(type);
			if (entity)
				removeEntity(entity);
		}

		public function removeEntityByName(name:String):void
		{
			var entity:Entity = getEntityByName(name);
			if (entity)
				removeEntity(entity);
		}

		public function getComponent(fullName:String):Component
		{
			var parts:Array = fullName.split(NameManager.SEPARATOR);
			var entityName:String = parts[0];
			var componentName:String = parts[1];

			var entity:Entity = getEntityByName(entityName);

			return (entity)
				? entity.getComponentByName(componentName)
				: null;
		}

		private function entityExists(name:String):Boolean
		{
			return name && (name in _entities);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get frameRate():int
		{
			return StageReference.stage.frameRate;
		}

		public function get started():Boolean
		{
			return _started;
		}

		public function set started(value:Boolean):void
		{
			if (value)
				start();
			else
				stop();
		}

		public function get startEvent():EventSender
		{
			return _startEvent;
		}

		public function get stopEvent():EventSender
		{
			return _stopEvent;
		}

		public function get tweenManager():TweenManager
		{
			return _tweenManager;
		}

		public function get context():Object
		{
			return _context;
		}

		public function set context(value:Object):void
		{
			_context = value;
		}

		public function get disposed():Boolean
		{
			return _disposed;
		}
	}

}