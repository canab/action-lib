package actionlib.gui.layouts
{
	import actionlib.gui.controls.Container;
	import actionlib.gui.controls.ControlBase;
	import actionlib.gui.interfaces.ILayout;

	public class FitLayout implements ILayout
	{
		public function FitLayout()
		{
		}

		public function apply(container:Container):void
		{
			for each (var item:ControlBase in container.controls)
			{
				item.move(0, 0);
				item.setSize(container.width, container.height);
			}
		}
	}
}
