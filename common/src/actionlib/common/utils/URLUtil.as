package actionlib.common.utils
{
	public class URLUtil
	{
		public static function getServerNameWithPort(url:String):String
		{
			// Find first slash; second is +1, start 1 after.
			var start:int = url.indexOf("/") + 2;
			var length:int = url.indexOf("/", start);
			return length == -1 ? url.substring(start) : url.substring(start, length);
		}

		public static function getServerName(url:String):String
		{
			if (StringUtil.startsWith(url, "file:///"))
				return "localhost";

			var sp:String = getServerNameWithPort(url);

			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = sp.indexOf("]");
			delim = (delim > -1) ? sp.indexOf(":", delim) : sp.indexOf(":");

			if (delim > 0)
				sp = sp.substring(0, delim);
			return sp;
		}

		public static function domainSuffixMatch(url:String, suffix:String):Boolean
		{
			var domain:String = getServerName(url);
			var matches:Boolean = StringUtil.endsWith(domain.toLowerCase(), suffix.toLowerCase());
			return matches;
		}

	}
}
