package actionlib.gui.controls
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class VerticalScrollBar extends ScrollBar
	{

		public function VerticalScrollBar(content:Sprite)
		{
			super(content);
		}

		override protected function applyScrollBounds():void
		{
			_dragController.bounds = new Rectangle(0, _minPosition, 0, _distance + buttonSize);
			_dragController.lockHorizontal = true;
		}

		override protected function get buttonPosition():int
		{
			return _scrollButton.y;
		}

		override protected function set buttonPosition(value:int):void
		{
			_scrollButton.y = value;
		}

		override protected function get linePosition():int
		{
			return _line.y;
		}

		override protected function get buttonSize():int
		{
			return _scrollButton.height;
		}

		override protected function get lineSize():int
		{
			return _line.height;
		}

	}
	
}