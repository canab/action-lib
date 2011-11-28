package actionlib.engine.rendering
{
	import actionlib.common.commands.AsincCommand;
	import actionlib.common.commands.ICancelableCommand;
	import actionlib.common.processing.EnterFrameProcessor;

	import flash.display.MovieClip;

	public class CachePrerenderer extends AsincCommand implements ICancelableCommand
	{
		private var _processor:EnterFrameProcessor = new EnterFrameProcessor();
		private var _cache:BitmapCache;
		private var _executed:Boolean;

		public function CachePrerenderer(cache:BitmapCache)
		{
			_cache = cache;
		}

		public function addClasses(classes:Array):CachePrerenderer
		{
			for each (var classRef:Class in classes)
			{
				addClass(classRef);
			}
			return this;
		}

		public function addClass(classRef:Class):CachePrerenderer
		{
			addClip(classRef, new classRef());
			return this;
		}

		public function addClip(key:Object, clip:MovieClip):CachePrerenderer
		{
			var frames:Vector.<BitmapFrame> = _cache.getFrames(key);
			var renderer:ClipPrerenderer = new ClipPrerenderer(clip, frames);
			_processor.addTarget(renderer);

			return this;
		}

		override public virtual function execute():void
		{
			_processor.completeEvent.addListener(onProcessorComplete);
			_processor.execute();
			_executed = true;
		}

		private function onProcessorComplete():void
		{
			_executed = false;
			dispatchComplete();
		}

		public function cancel():void
		{
			if (_executed)
			{
				_executed = false;
				_processor.cancel();
			}
		}
	}
}


