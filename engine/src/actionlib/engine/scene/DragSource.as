package actionlib.engine.scene
{
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.DisplayUtil;
	import actionlib.engine.core.Component;
	import actionlib.engine.scene.renderers.SpriteRenderer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class DragSource extends Component
	{
		public var lockHorizontal:Boolean = false;
		public var lockVertical:Boolean = false;
		public var targets:Array = [];
		
		private var _renderer:SpriteRenderer;
		private var _content:Sprite;
		private var _enabled:Boolean = true;
		private var _bounds:Rectangle;
		private var _currentTarget:DropTarget;
		
		private var _startEvent:EventSender = new EventSender(this);
		private var _finishEvent:EventSender = new EventSender(this);
		private var _dropEvent:EventSender = new EventSender(this);
		
		private var _startX:Number;
		private var _startY:Number;
		
		private var _dX:Number;
		private var _dY:Number;
		
		private var _positionChanged:Boolean = false;
		
		public function DragSource(renderer:SpriteRenderer)
		{
			_renderer = renderer;
			_content = Sprite(renderer.content);
			_content.mouseEnabled = true;
		}
		
		override protected function onInitialize():void 
		{
			enabled = _enabled;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			startDrag();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (_currentTarget)
			{
				_currentTarget.onDrop(this);
				_dropEvent.dispatch(_currentTarget);
			}
			else
			{
				_finishEvent.dispatch();
			}
			
			stopDrag();
		}
		
		private function startDrag():void
		{
			DisplayUtil.bringToFront(_content);
			
			_startX = _content.x;
			_startY = _content.y;
			
			_dX = _content.parent.mouseX - _content.x;
			_dY = _content.parent.mouseY - _content.y;
			
			_content.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_content.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			_startEvent.dispatch();
			
			addFrameListener(onEnterFrame);
		}
		
		private function stopDrag():void
		{
			_content.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_content.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			setCurrentTarget(null);
			removeProcessor(onEnterFrame);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var oldX:Number = _content.x;
			var oldY:Number = _content.y;
		
			if (!lockHorizontal)
				_content.x += _content.parent.mouseX - _dX - _content.x;
				
			if (!lockVertical)
				_content.y += _content.parent.mouseY - _dY - _content.y;
			
			if (_bounds)
				checkBounds();
				
			if (_content.x != oldX || _content.y != oldY)
			{
				_positionChanged = true;
				e.updateAfterEvent();
			}
		}
		
		private function checkBounds():void 
		{
			var rect:Rectangle = _content.getBounds(_content.parent);
			
			if (!lockHorizontal)
			{
				if (rect.left < _bounds.left)
					_content.x += _bounds.left - rect.left;
				else if (rect.right > _bounds.right)
					_content.x += _bounds.right - rect.right;
			}
			
			if (!lockVertical)
			{
				if (rect.top < _bounds.top)
					_content.y += _bounds.top - rect.top;
				else if (rect.bottom > _bounds.bottom)
					_content.y += _bounds.bottom - rect.bottom;
			}
		}
		
		private function onEnterFrame():void
		{
			if (_positionChanged)
			{
				_positionChanged = false;
				checkTargets();
			}
		}
		
		private function checkTargets():void
		{
			var newTarget:DropTarget = null;
			
			for each (var target:DropTarget in targets) 
			{
				if (target.renderer.content.hitTestObject(_renderer.content))
				{
					newTarget = target;
					break;
				}
			}
			
			if (newTarget != _currentTarget)
				setCurrentTarget(newTarget);
		}
		
		private function setCurrentTarget(target:DropTarget):void 
		{
			if (_currentTarget)
				_currentTarget.onOut(this);
				
			_currentTarget = target;
			
			if (_currentTarget)
				_currentTarget.onOver(this);
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			if (_enabled)
				_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			else
				_content.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function get startEvent():EventSender { return _startEvent; }
		public function get finishEvent():EventSender { return _finishEvent; }
		public function get dropEvent():EventSender { return _dropEvent; }
		
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(value:Rectangle):void 
		{
			_bounds = value;
		}
		
	}

}