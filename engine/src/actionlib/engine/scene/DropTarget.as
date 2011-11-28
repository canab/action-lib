package actionlib.engine.scene
{
	import actionlib.common.events.EventSender;
	import actionlib.engine.core.Component;
	import actionlib.engine.scene.renderers.SpriteRenderer;

	public class DropTarget extends Component
	{
		private var _renderer:SpriteRenderer;
		private var _overEvent:EventSender = new EventSender(this);
		private var _outEvent:EventSender = new EventSender(this);
		private var _dropEvent:EventSender = new EventSender(this);
		
		public function DropTarget(renderer:SpriteRenderer) 
		{
			_renderer = renderer;
		}
		
		public function onOver(source:DragSource):void 
		{
			_overEvent.dispatch(source);
		}
		
		public function onOut(source:DragSource):void 
		{
			_outEvent.dispatch(source);
		}
		
		public function onDrop(source:DragSource):void 
		{
			_dropEvent.dispatch(source);
		}
		
		public function get renderer():SpriteRenderer { return _renderer; }
		
		public function get overEvent():EventSender { return _overEvent; }
		public function get outEvent():EventSender { return _outEvent; }
		public function get dropEvent():EventSender { return _dropEvent; }
		
	}

}