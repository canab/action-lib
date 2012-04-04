package actionlib.engine.scene.renderers
{
	import actionlib.common.errors.NullPointerError;
	import actionlib.engine.components.Position;
	import actionlib.engine.components.Rotation;
	import actionlib.engine.components.Size;
	import actionlib.engine.core.Component;
	import actionlib.engine.scene.IVectorRenderer;
	import actionlib.engine.scene.VectorLayer;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class DisplayObjectRenderer extends Component implements IVectorRenderer
	{
		private var _content:DisplayObject;
		private var _layer:VectorLayer;

		private var _position:Position;
		private var _size:Size;
		private var _rotation:Rotation;
		private var _renderOnFrame:Boolean = false;
		private var _childIndex:int = -1;

		public function DisplayObjectRenderer(content:DisplayObject)
		{
			if (content == null)
				throw new NullPointerError();

			_content = content;
		}

		override protected function onDispose():void
		{
			layer = null;
		}

		public function render():void
		{
			if (_position)
			{
				_content.x = _position.x;
				_content.y = _position.y;
			}

			if (_rotation)
				_content.rotation = _rotation.degrees;

			if (_size)
				applySize();
		}

		private function updateRenderOnFrameState():void
		{
			if (_renderOnFrame)
			{
				addFrameListener(render);
				render();
			}
			else
			{
				removeProcessor(render);
			}
		}

		protected function applySize():void
		{
			_content.width = _size.width;
			_content.height = _size.height;
		}

		public function setScale(scale:Number):void
		{
			_content.scaleX = scale;
			_content.scaleY = scale;
		}

		public function getBounds(targetContainer:Sprite = null):Rectangle
		{
			return content.getBounds(targetContainer || content.parent);
		}


		//-- get/set --//


		public function setLayer(value:VectorLayer):DisplayObjectRenderer
		{
			this.layer = value;
			return this;
		}

		public function get layer():VectorLayer { return _layer; }

		public function set layer(value:VectorLayer):void
		{
			if (_layer)
				_layer.removeItem(this);

			_layer = value;

			if (_layer)
				_layer.addItem(this);
		}

		public function get position():Position { return _position; }

		public function set position(value:Position):void
		{
			_position = value;
			render();
		}

		public function get size():Size { return _size; }

		public function set size(value:Size):void
		{
			_size = value;
			render();
		}

		public function get rotation():Rotation { return _rotation; }

		public function set rotation(value:Rotation):void
		{
			_rotation = value;
			render();
		}

		public function get visible():Boolean
		{
			return _content.visible;
		}

		public function set visible(value:Boolean):void
		{
			_content.visible = value;
		}

		public function get content():DisplayObject { return _content; }

		public function get renderOnFrame():Boolean
		{
			return _renderOnFrame;
		}

		public function set renderOnFrame(value:Boolean):void
		{
			if (_renderOnFrame != value)
			{
				_renderOnFrame = value;
				updateRenderOnFrameState();
			}
		}

		public function get childIndex():int
		{
			if (_content.parent)
				return _content.parent.getChildIndex(_content);
			else
				return _childIndex;
		}

		public function set childIndex(value:int):void
		{
			_childIndex = value;
			if (_content.parent)
				_content.parent.setChildIndex(_content, _childIndex);
		}
	}

}