package
{
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.net.SharedObject;
	import flash.net.URLStream;
	import flash.text.TextField;
	import flash.text.engine.TextBlock;
	import flash.events.NetStatusEvent;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.StageOrientationEvent;
	import flash.display.StageOrientation;
	import flash.display.StageAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.net.*;
	import flash.events.*;

	public class main extends MovieClip
	{
		public static var main_stage:Stage;
		private var current_object:Object;
		public static var _debug:TextField;

		public function main()
		{
			this.init();
			Languages.init();
			LevelsPreviewHQ.init();
			LevelsPreviewLQ.init();
			Data.init();

			_debug = getChildByName("debug_text") as TextField;
			_debug.mouseEnabled = false;
			_debug.x = 0;
			_debug.y = 0;
			_debug.width = Data.width;
			_debug.height = Data.height;

			current_object = new Menu();
			addChildAt(current_object as DisplayObject, 0);
		}

		private function init():void
		{
			main_stage = stage;

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.mouseEnabled = false;
			this.mouseChildren = true;

			main.main_stage.addEventListener(Event.RESIZE, resize);
			main.main_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, resize);

			main.main_stage.addEventListener(MenuEvent.ON_DOWNLOAD, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_LEVELSPREVIEW, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_PLAY, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_FAIL, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_SUCCESS, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_PURCHASE, process_event);
			main.main_stage.addEventListener(MenuEvent.ON_RESTORE, process_event);

			stop();
		}

		private function resize(e:Event):void
		{
			Data.calc_sizes();
			current_object.resize();
			_debug.x = 0;
			_debug.y = 0;
			_debug.width = Data.width;
			_debug.height = Data.height;
		}

		private function process_event(e:MenuEvent):void
		{
			(current_object as IRemoveListeners).remove_listeners();
			removeChild(current_object as DisplayObject);

			if (e.type == MenuEvent.ON_DOWNLOAD)
			{
				current_object = new DownloadMenu(e.level);
			}
			else if (e.type == MenuEvent.ON_LEVELSPREVIEW)
			{
				current_object = new Menu();
			}
			else if (e.type == MenuEvent.ON_PLAY)
			{
				current_object = new Level(e.level, e.item);
			}
			else if (e.type == MenuEvent.ON_FAIL)
			{
				current_object = new Fail();
			}
			else if (e.type == MenuEvent.ON_SUCCESS)
			{
				current_object = new Success();
			}
			else if (e.type == MenuEvent.ON_PURCHASE)
			{
				current_object = new Purchase();
			}
			else if (e.type == MenuEvent.ON_RESTORE)
			{
				current_object = new Purchase(true);
			}

			addChildAt(current_object as DisplayObject, 0);
		}

		public static function debug(text:String)
		{
			_debug.appendText(text + "\n");
		}

	}
}