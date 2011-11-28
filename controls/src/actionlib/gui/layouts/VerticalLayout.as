package actionlib.gui.layouts
{
	import actionlib.gui.controls.Container;
	import actionlib.gui.controls.ControlBase;
	import actionlib.gui.interfaces.ILayout;

	public class VerticalLayout implements ILayout
	{
		public static const TOP:String = "top";
		public static const CENTER:String = "center";
		public static const BOTTOM:String = "bottom";

		private var _gap:int;
		private var _align:String;

		public function VerticalLayout(gap:int = 0, align:String = TOP)
		{
			_gap = gap;
			_align = align;
		}

		public function apply(container:Container):void
		{
			var y:int;

			switch (_align)
			{
				case TOP:
					y = 0;
					break;
				case CENTER:
					y = int(0.5 * container.height - 0.5 * getTotalHeight(container.controls));
					break;
				case BOTTOM:
					y = container.height - getTotalHeight(container.controls);
					break;
			}

			for each (var item:ControlBase in container.controls)
			{
				item.x = 0;
				item.y = y;
				y += item.height + _gap;
			}
		}

		private function getTotalHeight(items:Array):int
		{
			var height:int = 0;

			for each (var item:ControlBase in items)
			{
				if (height > 0)
					height += _gap;
				height += item.height;
			}

			return height;
		}
	}
}
