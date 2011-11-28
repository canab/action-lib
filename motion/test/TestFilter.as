package
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;

	import actionlib.motion.filter.FilterTween;
	import actionlib.motion.tween;

	public class TestFilter extends MotionTestBase
	{
		private var _sprites:Array = [];

		override protected function onInitialize():void
		{
			createSprites();
			testSingleFilter(_sprites[0]);
			testInstanceFilter(_sprites[1]);
			testMultipleFilters(_sprites[2]);
		}

		private function testMultipleFilters(sprite:Sprite):void
		{
			sprite.filters = [
					new GlowFilter(),
					new BevelFilter()
			];

			var filterTween1:FilterTween = FilterTween
					.byClass(GlowFilter)
					.to({blurX:20, blurY:20});
			var filterTween2:FilterTween = FilterTween
					.byClass(BevelFilter)
					.to({distance: 20});

			tween(sprite)
				.to({$filter: [filterTween1, filterTween2]})
				.onComplete(testMultipleFilters, sprite);
		}

		private function testInstanceFilter(sprite:Sprite):void
		{
			sprite.filters = [];

			var filterTween1:FilterTween = FilterTween
				.byInstance(new GlowFilter(0, 1, 20, 20, 2))
				.to({color:0x00FF00, strength:10});

			var filterTween2:FilterTween = FilterTween
				.byClass(GlowFilter)
				.to({blurX:30, blurY:30})
				.autoRemove();

			tween(sprite)
				.to({$filter: filterTween1})
				.tween()
					.to({$filter: filterTween2})
				.tween(1000)
				.tween()
					.onComplete(testInstanceFilter, sprite);
		}

		private function testSingleFilter(sprite:Sprite):void
		{
			sprite.filters = [new BlurFilter(0, 0)];
			var filterOn:FilterTween = FilterTween.to({blurX:15, blurY:15});
			var filterOff:FilterTween = FilterTween.to({blurX:0, blurY:0});

			tween(sprite)
				.to({$filter: filterOn})
				.tween()
				.to({$filter: filterOff})
				.onComplete(testSingleFilter, sprite);
		}

		private function createSprites():void
		{
			var rows:int = 4;
			var cols:int = 5;
			var gridSize:int = 100;

			for (var i:int = 0; i < rows; i++)
			{
				for (var j:int = 0; j < cols; j++)
				{
					var sprite:Sprite = createSprite(
							(j + 1) * gridSize,
							(i + 1) * gridSize);
					_sprites.push(sprite);
				}
			}
		}

	}
}
