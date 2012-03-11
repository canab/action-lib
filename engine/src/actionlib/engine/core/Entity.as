package actionlib.engine.core
{
	import actionlib.common.events.EventSender;

	public class Entity extends GroupBase
	{
		public static function fromComponents(...args):Entity
		{
			var entity:Entity = new Entity();
			entity.addComponents(args);
			return entity;
		}



	}

}