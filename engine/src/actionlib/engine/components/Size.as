package actionlib.engine.components
{
	public class Size
	{
		public var width:Number;
		public var height:Number;
		
		public function Size(width:Number = 1, height:Number = 1) 
		{
			this.width = width;
			this.height = height;
		}

		public function toString():String
		{
			return "Size[" + width + ", " + height + "]";
		}
	}

}