package actionlib.engine.core
{
	import actionlib.common.collections.ObjectMap;
	import actionlib.common.display.StageReference;
	import actionlib.common.errors.ItemNotFoundError;

	internal class ComponentActivity
	{
		private var _processors:ObjectMap = new ObjectMap(Function, ProcessorBase);
		private var _processManager:ProcessManager;

		function ComponentActivity(engine:Engine)
		{
			if (engine)
				initialize(engine);
		}

		public function initialize(engine:Engine):void
		{
			_processManager = engine.processManager;

			for each (var processor:ProcessorBase in _processors)
			{
				_processManager.addProcessor(processor);
			}
		}

		public function dispose():void
		{
			for each (var processor:ProcessorBase in _processors)
			{
				processor.disposed = true;
			}
		}

		public function addFrameListener(method:Function):void
		{
			assertMethodNotUsed(method);

			var processor:ProcessorBase = new FrameProcessor(method);
			pushProcessor(method, processor);
		}

		public function addDelayedCall(milliseconds:int, method:Function):void
		{
			assertMethodNotUsed(method);

			var frameCount:int = Math.max(milliseconds / 1000.0 * StageReference.stage.frameRate, 1);
			var processor:ProcessorBase = new DelayedProcessor(method, frameCount);
			pushProcessor(method, processor);
		}

		public function addTimer(milliseconds:int, method:Function):void
		{
			assertMethodNotUsed(method);

			var frameCount:int = Math.max(milliseconds / 1000.0 * StageReference.stage.frameRate, 1);
			var processor:ProcessorBase = new TimerProcessor(method, frameCount);
			pushProcessor(method, processor);
		}

		public function removeProcessor(method:Function):void
		{
			var processor:ProcessorBase = _processors[method];

			if (!processor)
				throw new ItemNotFoundError();

			processor.disposed = true;
			_processors.removeKey(method);
		}

		public function hasProcessor(method:Function):Boolean
		{
			return (_processors.containsKey(method));
		}

		private function pushProcessor(method:Function, processor:ProcessorBase):void
		{
			_processors[method] = processor;

			if (_processManager)
				_processManager.addProcessor(processor);
		}

		private function assertMethodNotUsed(method:Function):void
		{
			var processor:ProcessorBase = _processors[method];
			if (processor && !processor.disposed)
				throw new Error("Function is already used in " + _processors[method]);
		}
	}

}