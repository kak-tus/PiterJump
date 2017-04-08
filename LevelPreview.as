package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.filters.ColorMatrixFilter;
	import flash.events.MouseEvent;

	public class LevelPreview extends MovieClip
	{
		public var index:int;

		public function LevelPreview(_index:int)
		{
			index = _index;
			name = "level_preview_" + index;
			cacheAsBitmap = true;

			var lpr:MovieClip;

			if ((Data.orientation == "landscape" && Data.width > 1024) || (Data.orientation == "portrait" && Data.height > 1024))
			{
				lpr = LevelsPreviewHQ.current;
			}
			else
			{
				lpr = LevelsPreviewLQ.current;
			}

			lpr.gotoAndStop(index);

			var img:Bitmap = new Bitmap((lpr.getChildAt(0) as Bitmap).bitmapData);
			img.x = 0;
			img.y = 0;
			img.width = width;
			img.height = height;
			addChildAt(img, 0);

			var text:MovieClip = getChildByName("level") as MovieClip;
			(text.getChildByName("text") as TextField).text = index.toString();

			update_status();
		}

		public function update_status()
		{
			var jumped:MovieClip = getChildByName("jumped") as MovieClip;

			if (Data.levels_jumped[index - 1])
			{
				jumped.visible = true;
			}
			else
			{
				jumped.visible = false;
			}

			if (index <= 3)
			{
				if (index == 1)
				{
					addEventListener(MouseEvent.CLICK, goto_download);
				}
				else if (Data.levels_jumped[index - 2])
				{
					addEventListener(MouseEvent.CLICK, goto_download);
				}
			}
			else if (index == 4)
			{
				if (Data.purchased && Data.levels_jumped[index - 2])
				{
					addEventListener(MouseEvent.CLICK, goto_download);
				}
				else if (Data.levels_jumped[index - 2])
				{
					var restore:MovieClip = getChildByName("button_restore_purchase") as MovieClip;
					restore.visible = true;
					restore.addEventListener(MouseEvent.CLICK, goto_restore);
					addEventListener(MouseEvent.CLICK, goto_purchase);
				}
			}
			else
			{
				if (Data.purchased && Data.levels_jumped[index - 2])
				{
					addEventListener(MouseEvent.CLICK, goto_download);
				}
			}

			if (index == 1 || Data.levels_jumped[index - 2])
			{
				set_availible();
			}
			else
			{
				set_unavailible();
			}
		}

		private function set_unavailible():void
		{
			const rc:Number = 0.222, gc:Number = 0.707, bc:Number = 0.071;
			var filter:ColorMatrixFilter = new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);
			var farr:Array = new Array();
			farr.push(filter);
			filters = farr;
		}

		private function set_availible():void
		{
			var farr:Array = new Array();
			filters = farr;
		}

		private function goto_download(e:MouseEvent):void
		{
			if (!click_enabled())
			{
				return;
			}

			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_DOWNLOAD, true);
			ev.level = this.index;
			dispatchEvent(ev);
		}

		private function goto_purchase(e:MouseEvent):void
		{
			if (!click_enabled())
			{
				return;
			}

			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_PURCHASE, true);
			dispatchEvent(ev);
		}

		private function click_enabled():Boolean
		{
			if (Math.abs(Data.move_start - Data.move_stop) > 10 * Data.scaleY)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		private function goto_restore(e:MouseEvent):void
		{
			if (!click_enabled())
			{
				return;
			}

			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_RESTORE, true);
			dispatchEvent(ev);
		}

	}

}

