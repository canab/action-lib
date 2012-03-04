package actionlib.engine.core
{
	import flash.display.Shape;
	import flash.events.Event;

	internal class ProcessManager
	{
		private var _head:ProcessorBase;
		private var _tail:ProcessorBase;
		private var _frameDispatcher:Shape = new Shape();

		internal function start():void
		{
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		internal function stop():void 
		{
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		internal function onEnterFrame(e:Event):void
		{
			var processor:ProcessorBase = _head;

			while (processor)
			{
				var nextProcessor:ProcessorBase = processor.next;

				if (processor.isActive)
					processor.process();

				if (!processor.isActive)
					removeFromList(processor);

				processor = nextProcessor;
			}
		}

		internal function addProcessor(processor:ProcessorBase):void
		{
			addToList(processor);
		}

		internal function removeProcessor(processor:ProcessorBase):void
		{
			processor.disposed = true;
		}

		internal function findProcessor(component:Component, method:Function):ProcessorBase
		{
			for (var processor:ProcessorBase = _head; processor != null; processor = processor.next)
			{
				if (processor.component == component && processor.method == method)
					return processor;
			}
			
			return null;
		}

		private function addToList(processor:ProcessorBase):void
		{
			processor.next = null;
			processor.prev = _tail;

			if (_tail)
				_tail = _tail.next = processor;
			else
				_tail = _head = processor;
		}

		private function removeFromList(processor:ProcessorBase):void
		{
			var prevProcessor:ProcessorBase = processor.prev;
			var nextProcessor:ProcessorBase = processor.next;

			if (prevProcessor)
				prevProcessor.next = nextProcessor;

			if (nextProcessor)
				nextProcessor.prev = prevProcessor;

			if (processor == _head)
				_head = nextProcessor;

			if (processor == _tail)
				_tail = prevProcessor;
		}

	}

}