package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import actionlib.motion.TweenManager;
	import actionlib.motion.tween;

	public class TestRemove extends MotionTestBase
	{
		override protected function onInitialize():void
		{
			var sprite:Sprite = createSprite();
			sprite.x -= 100;
			createTween(sprite);

			sprite = createSprite();
			sprite.x += 100;
			createTween(sprite);
		}

		private function createTween(target:Sprite):void
		{
			tween(target)
				.to({scaleY: 2})
				.tween()
				.to({scaleY: 1})
				.onComplete(createTween, target);
		}

		override protected function onMouseOver(event:MouseEvent):void
		{
			TweenManager.removeTweensOf(event.target);
		}

		override protected function onMouseDown(event:MouseEvent):void
		{
			TweenManager.removeAll();
		}
	}
}
