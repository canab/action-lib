package actionlib.engine.scene.renderers
{
	import actionlib.common.query.conditions.isAnimation;
	import actionlib.common.query.fromDisplayTree;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class MovieClipRenderer extends ClipRenderer
	{
		private var _content:Sprite;
		private var _subClips:Vector.<MovieClip> = new <MovieClip>[];
		private var _totalFrames:int = 1;

		public function MovieClipRenderer(content:Sprite)
		{
			super(_content = content);
			initialize();
		}

		private function initialize():void
		{
			if (isAnimation(_content))
				pushClip(MovieClip(_content));

			fromDisplayTree(_content)
					.where(isAnimation)
					.apply(pushClip);
		}

		private function pushClip(clip:MovieClip):void
		{
			clip.gotoAndStop(1);
			_subClips.push(clip);
			_totalFrames = Math.max(_totalFrames, clip.totalFrames);
		}

		override protected function updateFrame():void
		{
			for each (var clip:MovieClip in _subClips)
			{
				clip.gotoAndStop(currentFrame % totalFrames);
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override public function get totalFrames():int
		{
			return _totalFrames;
		}
	}
}
