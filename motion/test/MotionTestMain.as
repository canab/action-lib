package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import actionlib.motion.TweenManager;

	[SWF(width="640", height="480", frameRate="30")]
	public class MotionTestMain extends Sprite
	{
		private var _field:TextField;

		public function MotionTestMain()
		{
			createDebugInfo();
			addEventListener(Event.ENTER_FRAME, refreshDebugInfo);

			new TestBasicTween().initialize(this);
//			new TestOverride().initialize(this);
//			new TestCustomProperties().initialize(this);
//			new TestFilter().initialize(this);
//			new TestRemove().initialize(this);
		}

		private function refreshDebugInfo(event:Event):void
		{
			_field.text = TweenManager.getDebugInfo();
			_field.height = _field.textHeight + 10;
		}

		private function createDebugInfo():void
		{
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat("_typewriter");
			_field.background = true;
			_field.border = true;
			_field.multiline = true;
			_field.width = 200;

			addChild(_field);
		}
	}
}
