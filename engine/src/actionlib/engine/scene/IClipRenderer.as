package actionlib.engine.scene
{
	import actionlib.common.events.EventSender;

	public interface IClipRenderer
	{
		function play():void;

		function playTo(frameNum:int):void;

		function playForward():void;

		function playReverse():void;

		function stop():void;

		function nextFrame():void;

		function prevFrame():void;

		function get totalFrames():int;

		function get currentFrame():int;

		function set currentFrame(value:int):void;

		function get playCompleteEvent():EventSender;
	}
}
