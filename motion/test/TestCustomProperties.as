package
{
	import flash.display.Sprite;

	import actionlib.motion.tween;

	public class TestCustomProperties extends MotionTestBase
	{
		private var _sprite:Sprite;

		override protected function onInitialize():void
		{
			_sprite = createSprite();
			createTween();
		}

		private function createTween():void
		{
			_sprite.scaleX = _sprite.scaleY = 0.1;
			
			tween(_sprite)
				.to({$scale: 1.5, alpha: 0.2})
				.tween()
				.tween(500)
				.to({$scale: 0.1, alpha: 1.0})
				.onComplete(createTween);
		}

	}
}
