package actionlib.common.errors
{
	public class NullParameterError extends Error
	{
		public function NullParameterError(message:String = "Parameter is null")
		{
			super(message);
		}
	}
}
