package actionlib.gui.controls
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class HorizontalScrollBar extends ScrollBar
	{
		public function HorizontalScrollBar(content:Sprite)
		{
			super(content);
		}

		override protected function applyScrollBounds():void
		{
			_dragController.bounds = new Rectangle(_minPosition, 0, _distance + buttonSize, 0);
			_dragController.lockVertical = true;
		}

		override protected function get buttonPosition():int
		{
			return _scrollButton.x;
		}

		override protected function set buttonPosition(value:int):void
		{
			_scrollButton.x = value;
		}

		override protected function get linePosition():int
		{
			return _line.x;
		}

		override protected function get buttonSize():int
		{
			return _scrollButton.width;
		}

		override protected function get lineSize():int
		{
			return _line.width;
		}
	}

}