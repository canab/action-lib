package actionlib.common.logging.adapters
{
	import actionlib.common.logging.ILogAdapter;
	import actionlib.common.logging.LogLevel;

	public class RecorderAdapter implements ILogAdapter
	{
		private var _nextAdapter:ILogAdapter;
		private var _records:Array = [];
		private var _active:Boolean = false;

		public function RecorderAdapter(nextAdapter:ILogAdapter)
		{
			_nextAdapter = nextAdapter;
		}

		public function print(sender:Object, level:LogLevel, message:String):void
		{
			if (_active)
				_records.push(message);

			_nextAdapter.print(sender,  level, message);
		}

		public function start():void
		{
			_active = true;
		}

		public function stopRecording():void
		{
			_active = false;
		}

		public function clear():void
		{
			_records = [];
		}

		public function getRecordedString():String
		{
			return _records.join("\n");
		}

	}
}
