package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.events.StageOrientationEvent;
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;

	public class DownloadMenu extends MovieClip implements IRemoveListeners
	{
		private var level:int;
		private var btns:MovieClip;
		private var img:Bitmap;
		private var back:MovieClip;
		private var vd:VideoDownloader;
		private var all_downloaded_flag_hq:Boolean;
		private var all_downloaded_flag_lq:Boolean;
		private var alert:DownloadError;

		public function DownloadMenu(_level:int)
		{
			level = _level;

			btns = getChildByName("download_buttons") as MovieClip;
			mark_downloaded();

			back = getChildByName("button_back") as MovieClip;
			back.x = 0;

			var lpr:LevelsPreviewHQ = LevelsPreviewHQ.current as LevelsPreviewHQ;
			lpr.gotoAndStop(level);

			img = new Bitmap((lpr.getChildAt(0) as Bitmap).bitmapData);
			img.x = 0;
			img.y = 0;
			addChildAt(img, 0);

			add_listeners();
			resize();
		}

		public function resize():void
		{
			x = 0;
			y = 0;

			img.width = img.width * Data.height / img.height;
			img.height = Data.height;

			back.y = Data.height - 20 * Data.scaleX;
			back.x = 20 * Data.scaleX;
			back.scaleX = btns.scaleX;
			back.scaleY = btns.scaleY;

			var height_to_center:Number;

			if (Data.orientation == "landscape")
			{
				btns.width = btns.width * Data.height / btns.height;
				btns.height = Data.height;
				height_to_center = Data.height;
			}
			else
			{
				btns.height = btns.height * Data.width / btns.width;
				btns.width = Data.width;

				if (btns.height > Data.height - back.height - 20 * Data.scaleX)
				{
					var new_height:Number = Data.height - back.height - 20 * Data.scaleX;
					var sc:Number = new_height / btns.height;
					btns.height = new_height;
					btns.width = btns.width * sc;
					height_to_center = Data.height - back.height - 20 * Data.scaleX;
				}
				else
				{
					height_to_center = Data.height;
				}
			}

			btns.scaleX *= 0.90;
			btns.scaleY *= 0.90;
			btns.x = Data.width / 2 - btns.width / 2;
			btns.y = height_to_center / 2 - btns.height / 2;

			if (alert)
			{
				alert.resize();
			}
		}

		private function add_listeners():void
		{
			main.main_stage.addEventListener(KeyboardEvent.KEY_UP, go_back);
			back.addEventListener(MouseEvent.CLICK, go_back_btn);
			btns.addEventListener(MenuEvent.ON_BUTTON, start_download);
		}

		public function remove_listeners():void
		{
			if (vd)
			{
				vd.removeEventListener(MenuEvent.ON_DOWNLOADED, downloaded);
				vd.removeEventListener(MenuEvent.ON_DOWNLOADERROR, download_error);
				vd.stop_download();
			}

			removeEventListener(KeyboardEvent.KEY_UP, go_back);
			back.removeEventListener(MouseEvent.CLICK, go_back_btn);
			btns.removeEventListener(MenuEvent.ON_BUTTON, start_download);
		}

		private function go_back(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
				dispatchEvent(ev);
			}
		}

		private function go_back_btn(e:MouseEvent):void
		{
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
			dispatchEvent(ev);
		}

		private function go_play(_quality:String):void
		{
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_PLAY, true);
			ev.level = level;
			ev.item = _quality;
			dispatchEvent(ev);
		}

		private function start_download(e:MenuEvent):void
		{
			if (vd)
			{
				vd.stop_download();
				vd = null;
				mark_downloaded();
			}
			else
			{
				if (e.item == "button_download_lq" && Data.levels_downloaded_lq[level - 1] == 1)
				{
					go_play("lq");
				}
				else if (e.item == "button_download_lq")
				{
					vd = new VideoDownloader(level, "lq", e.obj as Button);
				}
				else if (e.item == "button_download_hq" && Data.levels_downloaded_hq[level - 1] == 1)
				{
					go_play("hq");
				}
				else if (e.item == "button_download_hq")
				{
					vd = new VideoDownloader(level, "hq", e.obj as Button);
				}
				else if (e.item == "button_download_all_lq" && !all_downloaded_flag_lq)
				{
					vd = new VideoDownloader(0, "lq", e.obj as Button);
				}
				else if (e.item == "button_download_all_hq" && !all_downloaded_flag_hq)
				{
					vd = new VideoDownloader(0, "hq", e.obj as Button);
				}

				if (vd)
				{
					vd.addEventListener(MenuEvent.ON_DOWNLOADED, downloaded);
					vd.addEventListener(MenuEvent.ON_DOWNLOADERROR, download_error);
				}
			}
		}

		private function mark_downloaded():void
		{
			if (Data.levels_downloaded_lq[level - 1])
			{
				(btns.getChildByName("button_download_lq") as Button).set_text("button_play_lq");
			}
			if (Data.levels_downloaded_hq[level - 1])
			{
				(btns.getChildByName("button_download_hq") as Button).set_text("button_play_hq");
			}

			all_downloaded_flag_hq = true;
			all_downloaded_flag_lq = true;
			for (var i:int = 1; i <= Data.levels_count; i++)
			{
				if (Data.levels_downloaded_hq[i - 1] == 0)
				{
					all_downloaded_flag_hq = false;
				}
				if (Data.levels_downloaded_lq[i - 1] == 0)
				{
					all_downloaded_flag_lq = false;
				}
			}

			if (all_downloaded_flag_hq)
			{
				(btns.getChildByName("button_download_all_hq") as Button).set_text("button_downloaded_all_hq");
			}
			if (all_downloaded_flag_lq)
			{
				(btns.getChildByName("button_download_all_lq") as Button).set_text("button_downloaded_all_lq");
			}
		}

		private function downloaded(e:MenuEvent):void
		{
			vd = null;
			mark_downloaded();
		}

		private function download_error(e:MenuEvent):void
		{
			vd.stop_download();
			vd = null;
			mark_downloaded();

			alert = new DownloadError("test");
			addChild(alert);
		}
	}
}
