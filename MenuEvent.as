package
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
		public static const ON_DOWNLOAD:String = "onDownload";
		public static const ON_PLAY:String = "onPlay";
		public static const ON_LEVELSPREVIEW:String = "onLevelsPreview";
		public static const ON_BUTTON:String = "onButton";
		public static const ON_PURCHASE:String = "onPurchase";
		public static const ON_DOWNLOADED:String = "onDownloaded";
		public static const ON_DOWNLOADERROR:String = "onDownloadError";
		public static const ON_PAUSE:String = "onPause";
		public static const ON_RESUME:String = "onResume";
		public static const ON_SUCCESS:String = "onSuccess";
		public static const ON_FAIL:String = "onFail";
		public static const ON_RESTORE:String = "onRestore";

		public var level:int;
		public var item:String;
		public var parent:Object;
		public var obj:Object;

		public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
	}

}