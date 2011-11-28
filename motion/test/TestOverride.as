package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import actionlib.motion.tween;

	public class TestOverride extends MotionTestBase
	{
		private var _sprite:Sprite;

		override protected function onInitialize():void
		{
			_sprite = createSprite();
		}

		override protected function onMouseMove(event:MouseEvent):void
		{
			tween(_sprite).to({x: event.stageX, y:event.stageY});
		}

		override protected function onMouseOver(event:MouseEvent):void
		{
			tween(_sprite).to({alpha: 0});
		}

		override protected function onMouseOut(event:MouseEvent):void
		{
			tween(_sprite).to({alpha: 1});
		}
	}
}
