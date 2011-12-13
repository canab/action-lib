package actionlib.engine.rendering
{
	import flash.display.BitmapData;

	public class BitmapFrame
	{
		public var x:int;
		public var y:int;
		public var data:BitmapData;

		public function get dataSize():int
		{
			return data.width * data.height * (data.transparent ? 4 : 3);
		}
	}
}