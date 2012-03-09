package actionlib.engine.core
{
	import actionlib.common.errors.AlreadyDisposedError;

	internal class ComponentGroup extends ComponentBase
	{
		private var _head:ComponentBase;
		private var _tail:ComponentBase;


		//-- initialize/dispose --//


		override internal function initialize(engine:Engine):void
		{
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				comp.initialize(engine);
			}

			super.initialize(engine);
		}

		override internal function dispose():void
		{
			super.dispose();

			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				comp.dispose();
			}
		}


		//-- child components --//


		public function addComponent(component:ComponentBase):void
		{
			if (disposed)
				throw new AlreadyDisposedError();

			if (component.parent != null)
				throw new Error("Component is added to another group");

			addToList(component);
			component.parent = this;

			if (initialized)
				component.initialize(engine);
		}

		public function removeComponent(component:ComponentBase):void
		{
			if (disposed)
				throw new AlreadyDisposedError();

			if (component.parent != this)
				throw new Error("Component is not added to this group");

			if (component.initialized)
				component.dispose();

			component.parent = null;
			removeFromList(component);
		}


		//-- selectors --//


		public function getComponentByName(name:String):*
		{
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp.name == name)
					return comp;
			}
			return null;
		}

		public function getComponentByType(type:Class):*
		{
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp is type)
					return comp;
			}
			return null;
		}

		public function getAllByName(name:String):Array
		{
			var result:Array = [];
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp.name == name)
					result.push(comp);
			}
			return result;
		}

		public function getAllByType(type:Class):Array
		{
			var result:Array = [];
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp is type)
					result.push(comp);
			}
			return result;
		}

		public function removeComponentByName(name:String):Boolean
		{
			//noinspection LoopStatementThatDoesntLoopJS
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp.name == name)
				{
					removeComponent(comp);
					return true;
				}
			}
			return false;
		}

		public function removeComponentByType(type:Class):Boolean
		{
			//noinspection LoopStatementThatDoesntLoopJS
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				if (comp is type)
				{
					removeComponent(comp);
					return true;
				}
			}
			return false;
		}

		public function removeAllByName(name:String):int
		{
			var count:int = 0;
			var component:ComponentBase = _head;
			while (component != null)
			{
				var next:ComponentBase = component.next;
				if (component.name == name)
				{
					removeComponent(component);
					count++;
				}
				component = next;
			}
			return count;
		}

		public function removeAllByType(type:Class):int
		{
			var count:int = 0;
			var component:ComponentBase = _head;
			while (component != null)
			{
				var next:ComponentBase = component.next;
				if (component is type)
				{
					removeComponent(component);
					count++;
				}
				component = next;
			}
			return count;
		}

		public function getComponentList():Array
		{
			var result:Array = [];
			for (var comp:ComponentBase = _head; comp != null; comp = comp.next)
			{
				result.push(comp);
			}
			return result;
		}


		//-- linked list --//


		private function addToList(item:ComponentBase):void
		{
			item.next = null;
			item.prev = _tail;

			if (_tail)
				_tail = _tail.next = item;
			else
				_tail = _head = item;
		}

		private function removeFromList(item:ComponentBase):void
		{
			var prevItem:ComponentBase = item.prev;
			var nextItem:ComponentBase = item.next;

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
