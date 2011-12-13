package actionlib.engine.rendering
{
	internal class ClipPrerendererStats
	{
		private var _totalBytes:uint = 0;
		private var _framesRendered:uint = 0;
		private var _framesReused:uint = 0;

		internal function addReusedFrame():void
		{
			_framesReused++;
		}

		internal function addRenderedFrame(frame:BitmapFrame):void
		{
			_framesRendered++;
			_totalBytes += frame.dataSize;
		}

		public function getStats():String
		{
			return "Render stats:"
					+ "\n\t frames rendered: " + _framesRendered
					+ "\n\t frames reused: " + _framesReused
					+ "\n\t data size: " + Math.round(_totalBytes / 1000) / 1000.0 + " MB";
		}

	}
}
