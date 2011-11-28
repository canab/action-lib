package actionlib.gui.interfaces
{
	import flash.display.DisplayObject;

	public interface ITooltip
	{
		function get content():DisplayObject;
		function set text(value:String):void;
	}
}
