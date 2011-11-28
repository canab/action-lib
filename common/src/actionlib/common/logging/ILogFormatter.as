package actionlib.common.logging
{
	public interface ILogFormatter
	{
		function format(sender:String, level:String, message:String):String;
	}
}
