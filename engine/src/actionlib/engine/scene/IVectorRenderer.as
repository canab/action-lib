package actionlib.engine.scene
{
	import flash.display.DisplayObject;

	public interface IVectorRenderer
	{
		function get content():DisplayObject;
		function get childIndex():int;
		function setScale(value:Number):void;
	}
	
}