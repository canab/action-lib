package actionlib.engine.scene
{
	import actionlib.common.errors.ItemNotFoundError;
	import actionlib.common.geom.Vector2;
	import actionlib.engine.core.Component;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class VectorLayer extends Component
	{
		private var _content:Sprite;
		private var _items:Vector.<IVectorRenderer>;
		private var _enableOrdering:Boolean = false;

		public function VectorLayer(content:Sprite = null)
		{
			_content = content || new Sprite();
			_content.mouseEnabled = false;
			_items = new Vector.<IVectorRenderer>();
		}

		override protected function onInitialize():void
		{
			if (_enableOrdering)
				addFrameListener(orderItems);
		}

		public function addItem(item:IVectorRenderer):void
		{
			_items.push(item);

			var childIndex:int = item.childIndex;

			if (childIndex >= 0 && childIndex < _content.numChildren)
				_content.addChildAt(item.content, childIndex);
			else
				_content.addChild(item.content);
		}

		public function removeItem(item:IVectorRenderer):void
		{
			var index:int = _items.indexOf(item);
			if (index == -1)
			{
				throw new ItemNotFoundError();
			}
			else
			{
				_items.splice(index, 1);
				_content.removeChild(item.content);
			}
		}

		private function orderItems():void
		{
			//ordering
			if (_content.numChildren == 0)
				return;

			var prevChild:DisplayObject = _content.getChildAt(0);

			for (var i:int = 1; i < _content.numChildren; i++)
			{
				var currentChild:DisplayObject = _content.getChildAt(i);

				if (currentChild.y < prevChild.y)
				{
					var j:int = i - 1;

					while (j >= 0 && currentChild.y < _content.getChildAt(j).y)
					{
						j--;
					}

					_content.setChildIndex(currentChild, j + 1);
				}
				else
				{
					prevChild = currentChild;
				}
			}
		}

		public function bringToFront(item:IVectorRenderer):void
		{
			if (item.content.parent != _content)
				throw new ItemNotFoundError();

			_content.setChildIndex(item.content, _content.numChildren - 1);
		}

		public function sendToBack(item:IVectorRenderer):void
		{
			if (item.content.parent != _content)
				throw new ItemNotFoundError();

			_content.setChildIndex(item.content, 0);
		}

		public function getMousePosition(output:Vector2 = null):Vector2
		{
			if (!output)
				output = new Vector2();

			output.x = _content.mouseX;
			output.y = _content.mouseY;
			return output;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get content():Sprite
		{
			return _content;
		}

		public function get enableOrdering():Boolean
		{
			return _enableOrdering;
		}

		public function set enableOrdering(value:Boolean):void
		{
			if (_enableOrdering != value)
			{
				_enableOrdering = value;

				if (isInitialized)
				{
					if (_enableOrdering)
						addFrameListener(orderItems);
					else
						removeProcessor(orderItems);
				}
			}
		}
	}

}