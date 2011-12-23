package actionlib.motion.properties
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class VolumeProperty implements ITweenProperty
	{
		private var _channel:SoundChannel;
		private var _startValue:Number;
		private var _endValue:Number;
		private var _transform:SoundTransform;

		public function initialize(target:Object, endValue:Object):void
		{
			_channel = SoundChannel(target);
			_transform = _channel.soundTransform;
			_startValue = _transform.volume;
			_endValue = Number(endValue);
		}

		public function applyTween(position:Number):void
		{
			_transform.volume = _startValue + position * (_endValue - _startValue);
			_channel.soundTransform = _transform;
		}

		public function applyComplete():void
		{
			_transform.volume = _endValue;
			_channel.soundTransform = _transform;
		}
	}
}
