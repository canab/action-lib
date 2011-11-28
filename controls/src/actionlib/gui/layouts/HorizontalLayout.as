package actionlib.gui.layouts
{
	import actionlib.gui.controls.Container;
	import actionlib.gui.controls.ControlBase;
	import actionlib.gui.interfaces.ILayout;

	public class HorizontalLayout implements ILayout
	{
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";

		private var _gap:int;
		private var _align:String;

		public function HorizontalLayout(gap:int = 0, align:String = LEFT)
		{
			_gap = gap;
			_align = align;
		}

		public function apply(container:Container):void
		{
			var x:int;

			switch (_align)
			{
				case LEFT:
					x = 0;
					break;
				case CENTER:
					x = int(0.5 * container.width - 0.5 * getTotalWidth(container.controls));
					break;
				case RIGHT:
					x = container.width - getTotalWidth(container.controls);
					break;
			}

			for each (var item:ControlBase in container.controls)
			{
				item.x = x;
				item.y = 0;
				x += item.width + _gap;
			}
		}

		private function getTotalWidth(items:Array):int
		{
			var width:int = 0;

			for each (var item:ControlBase in items)
			{
				if (width > 0)
					width += _gap;
				width += item.width;
			}

			return width;
		}
	}
}
