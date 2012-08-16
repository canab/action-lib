package actionlib.engine.core
{
	import flash.display.Shape;
	import flash.events.Event;

	internal class ProcessManager
	{
		private var _head:ProcessorBase;
		private var _tail:ProcessorBase;
		private var _frameDispatcher:Shape = new Shape();
		private var _processorsToAdd:Array = [];

		internal var currentTick:uint = 0;

		internal function start():void
		{
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, doStep);
		}
		
		internal function stop():void 
		{
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, doStep);
		}

		internal function doStep(e:Event = null):void
		{
			currentTick += 1;

			var processor:ProcessorBase = _head;

			while (processor)
			{
				var nextProcessor:ProcessorBase = processor.next;

				if (!processor.disposed)
					processor.process();

				if (processor.disposed)
					removeFromList(processor);

				processor = nextProcessor;
			}

			addQueuedProcessors();
		}

		private function addQueuedProcessors():void
		{
			for each (var processor:ProcessorBase in _processorsToAdd)
			{
				addToList(processor);
			}
			_processorsToAdd.length = 0;
		}

		internal function addProcessor(processor:ProcessorBase):void
		{
			_processorsToAdd.push(processor);
		}


		//-- linked list --//


		private function addToList(item:ProcessorBase):void
		{
			item.next = null;
			item.prev = _tail;

			if (_tail)
				_tail = _tail.next = item;
			else
				_tail = _head = item;
		}

		private function removeFromList(item:ProcessorBase):void
		{
			var prevItem:ProcessorBase = item.prev;
			var nextItem:ProcessorBase = item.next;

			if (prevItem)
				prevItem.next = nextItem;

			if (nextItem)
				nextItem.prev = prevItem;

			if (item == _head)
				_head = nextItem;

			if (item == _tail)
				_tail = prevItem;
		}
	}

}