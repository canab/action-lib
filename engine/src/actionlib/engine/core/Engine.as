package actionlib.engine.core
{
	import actionlib.common.commands.CallFunctionCommand;
	import actionlib.common.commands.ICommand;
	import actionlib.common.display.StageReference;
	import actionlib.common.errors.AlreadyDisposedError;
	import actionlib.common.errors.AlreadyInitializedError;
	import actionlib.common.errors.NotInitializedError;
	import actionlib.common.events.EventSender;
	import actionlib.common.logging.Logger;
	import actionlib.common.utils.ArrayUtil;
	import actionlib.motion.TweenManager;
	import actionlib.motion.Tweener;

	public class Engine
	{
		internal var nameManager:NameManager = new NameManager();

		private var _logger:Logger = new Logger(this);

		private var _resumeEvent:EventSender = new EventSender(this);
		private var _pauseEvent:EventSender = new EventSender(this);

		private var _processManager:ProcessManager;
		private var _tweenManager:TweenManager;
		private var _entities:Vector.<Entity> = new <Entity>[];
		private var _paused:Boolean = true;
		private var _initialized:Boolean = false;
		private var _disposed:Boolean = false;
		private var _context:Object;

		private var _postProcessingCommands:Array = [];
		private var _processingState:Boolean;

		public function Engine()
		{
			_processManager = new ProcessManager();
			_tweenManager = new TweenManager();
		}


		//-- initialization --//


		public function initialize():void
		{
			if (_initialized)
				throw new AlreadyInitializedError();

			_processingState = true;

			for each (var entity:Entity in _entities)
			{
				entity.initialize();
			}

			_processingState = false;

			_initialized = true;

			processPostCommands();
			resume();
		}

		public function dispose():void
		{
			if (!_initialized)
				throw new NotInitializedError();

			if (_disposed)
				throw new AlreadyDisposedError();

			_processingState = true;

			for each (var entity:Entity in _entities)
			{
				entity.dispose();
			}

			_processingState = false;

			processPostCommands();

			_processManager.stop();
			_tweenManager.removeAll();
			_disposed = true;

			_logger.debug("disposed");
		}

		private function processPostCommands():void
		{
			for each (var command:ICommand in _postProcessingCommands)
			{
				command.execute();
			}
			_postProcessingCommands.length = 0;
		}

		private function ensureIsReady():void
		{
			if (!_initialized)
				throw new NotInitializedError();

			if (_disposed)
				throw new AlreadyDisposedError();
		}


		//-- state --//


		public function pause():void
		{
			ensureIsReady();

			if (_paused)
				return;

			_paused = true;
			_processManager.stop();
			_tweenManager.pauseAll();
			_logger.debug("paused");
			_pauseEvent.dispatch();
		}

		public function resume():void
		{
			ensureIsReady();

			if (!_paused)
				return;

			_paused = false;
			_processManager.start();
			_tweenManager.resumeAll();
			_logger.debug("resumed");
			_resumeEvent.dispatch();
		}


		//-- processing --//


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

		public function doStepsForce(stepsCount:int = 1):void
		{
			if (!_initialized)
				throw new NotInitializedError();

			if (_disposed)
				throw new AlreadyDisposedError();

			for (var i:int = 0; i < stepsCount; i++)
			{
				_processManager.onEnterFrame(null);
			}
		}

		public function tween(target:Object, duration:Number = -1):Tweener
		{
			return _tweenManager.tween(target, duration);
		}


		//-- entities --//


		public function addEntity(entity:Entity):void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (_processingState)
			{
				_postProcessingCommands.push(new CallFunctionCommand(addEntity, arguments));
				return;
			}

			if (!entity.name)
				entity.name = nameManager.getUniqueName();

			_entities.push(entity);

			entity.engine = this;

			if (_initialized)
				entity.initialize();
		}

		public function removeEntity(entity:Entity):void
		{
			if (_disposed)
				throw new AlreadyDisposedError();

			if (_processingState)
			{
				_postProcessingCommands.push(new CallFunctionCommand(removeEntity, arguments));
				return;
			}

			if (_initialized)
				entity.dispose();

			ArrayUtil.removeItemSafe(_entities, entity);
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


		//-- get/set --//


		public function get frameRate():int
		{
			return StageReference.stage.frameRate;
		}

		public function get paused():Boolean { return _paused; }

		public function set paused(value:Boolean):void
		{
			if (value)
				pause();
			else
				resume();
		}

		public function get pauseEvent():EventSender { return _pauseEvent; }

		public function get resumeEvent():EventSender { return _resumeEvent; }

		public function get tweenManager():TweenManager { return _tweenManager; }

		public function get context():Object { return _context; }

		public function set context(value:Object):void { _context = value; }

		public function get initialized():Boolean { return _initialized; }

		public function get disposed():Boolean { return _disposed; }
	}

}