package actionlib.engine.core
{
	import actionlib.common.events.EventSender;

	public class Entity extends ComponentGroup
	{
		public static function fromComponents(...args):Entity
		{
			var entity:Entity = new Entity();

			for each (var component:ComponentBase in args)
			{
				entity.addComponent(component);
			}

			return entity;
		}


		//-- instance --//


		private var _disposeEvent:EventSender;

		override internal function dispose():void
		{
			super.dispose();

			if (_disposeEvent)
				_disposeEvent.dispatch();
		}


		//-- get/set --//


		public function get disposeEvent():EventSender
		{
			if (!_disposeEvent)
				_disposeEvent = new EventSender(this);

			return _disposeEvent;
		}
	}

}