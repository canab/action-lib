package actionlib.common.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BrowserUtil
	{
		public static const SELF:String = "_self";
		public static const BLANK:String = "_blank";
		public static const PARENT:String = "_parent";
		public static const TOP:String = "_top";

		public static function navigateTop(url:String):void
		{
			navigate(url, TOP)
		}

		public static function navigateBlank(url:String):void
		{
			navigate(url, BLANK)
		}

		public static function navigateParent(url:String):void
		{
			navigate(url, PARENT)
		}

		public static function navigateSelf(url:String):void
		{
			navigate(url, SELF)
		}

		public static function navigate(url:String, window:String):void
		{
			if (ExternalInterface.available)
			{
				try
				{
					var browser:String = ExternalInterface.call(
						"function getBrowser(){return navigator.userAgent}") as String;

					if (browser.indexOf("Firefox") != -1 || browser.indexOf("MSIE 7.0") != -1)
					{
						ExternalInterface.call('window.open("' + url + '","' + window + '")');
					}
					else
					{
					   navigateToURL(new URLRequest(url), window);
					}
				}
				catch (e:Error)
				{
				   navigateToURL(new URLRequest(url), window);
				}
			}
			else
			{
			   navigateToURL(new URLRequest(url), window);
			}
		}

		public static function getURL():String
		{
			var result:String = null;

			if (ExternalInterface.available)
				result =  ExternalInterface.call("eval", "window.location.href");

			return result;
		}
	}
}