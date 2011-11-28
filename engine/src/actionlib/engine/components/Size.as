package actionlib.engine.components
{
	import actionlib.engine.core.Component;

	public class Size extends Component
	{
		public var width:Number;
		public var height:Number;
		
		public function Size(width:Number = 1, height:Number = 1) 
		{
			this.width = width;
			this.height = height;
		}
		
	}

}