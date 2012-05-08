package actionlib.engine.scene
{
	import actionlib.common.utils.ArrayUtil;
	import actionlib.engine.core.Component;

	public class RandomAnimations extends Component
	{
		private var _period:int;
		private var _maxCount:int;
		private var _items:Vector.<IClipRenderer> = new <IClipRenderer>[];
		private var _nowPlaying:Vector.<IClipRenderer> = new <IClipRenderer>[];

		public function RandomAnimations(period:int = 1000, maxCount:int = 2)
		{
			_period = period;
			_maxCount = maxCount;
		}

		override protected virtual function onInitialize():void
		{
			addTimer(_period, playNext);
		}

		public function addItems(renderers:Vector.<IClipRenderer> = null):void
		{
			for each (var clipRenderer:IClipRenderer in renderers)
			{
				addItem(clipRenderer);
			}
		}

		public function addItem(clipRenderer:IClipRenderer):void
		{
			_items.push(clipRenderer);
			clipRenderer.currentFrame = clipRenderer.totalFrames;
			clipRenderer.playCompleteEvent.addListener(onPlayComplete);
		}

		private function playNext():void
		{
			if (_nowPlaying.length >= _maxCount)
				return;

			if (_items.length == 0)
				return;

			var clip:IClipRenderer = ArrayUtil.getRandomItem(_items);

			if (_nowPlaying.indexOf(clip) == -1)
			{
				_nowPlaying.push(clip);

				clip.currentFrame = 1;
				clip.playForward();
			}
		}

		private function onPlayComplete(clip:IClipRenderer):void
		{
			ArrayUtil.removeItem(_nowPlaying, clip);
		}
	}
}
