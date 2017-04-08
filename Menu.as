package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.StageOrientationEvent;
	import flash.display.StageOrientation;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.net.SharedObject;
	import flash.text.TextField;

	public class Menu extends MovieClip implements IRemoveListeners
	{
		private var images:Array = new Array();
		private var image_width;
		private var image_height;
		private var start_move_Y:int;
		private var started_move:Boolean = false;
		private var last_delta:Number;
		private var last_deltas:Array;

		public function Menu()
		{
			add_levels();

			add_listeners();
			resize();

			for each (var img:MovieClip in images)
			{
				addChild(img);
			}
		}

		private function add_listeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			addEventListener(MouseEvent.MOUSE_MOVE, mouse_move);
		}

		public function remove_listeners():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			removeEventListener(MouseEvent.MOUSE_UP, mouse_up);
			removeEventListener(MouseEvent.MOUSE_MOVE, mouse_move);

			removeEventListener(Event.ENTER_FRAME, on_frame);
			removeEventListener(Event.ENTER_FRAME, on_frame_back_scroll);
		}

		private function add_levels():void
		{
			var img:LevelPreview;

			for (var i:int = 1; i <= Data.levels_count; i++)
			{
				img = new LevelPreview(i);
				images.push(img);
			}

			image_width = img.width;
			image_height = img.height;
		}

		private function mouse_down(e:MouseEvent):void
		{
			if (started_move)
			{
				return;
			}

			started_move = true;
			start_move_Y = e.stageY
			last_deltas = new Array();
			last_delta = 0;
			Data.move_start = e.stageY;
		}

		private function mouse_up(e:MouseEvent):void
		{
			started_move = false;
			addEventListener(Event.ENTER_FRAME, on_frame);
			Data.move_stop = e.stageY;
		}

		private function mouse_move(e:MouseEvent):void
		{
			image_move(e.stageY);
		}

		private function image_move(local_y:int):void
		{
			if (!started_move)
			{
				return;
			}

			var delta:int = local_y - start_move_Y;

			image_move_by_delta(delta);
			start_move_Y = local_y;

			if (delta != 0)
			{
				last_deltas.push(delta);
			}
			if (last_deltas.length > 3)
			{
				last_deltas.shift();
			}
			last_delta = 0;
			for each (delta in last_deltas)
			{
				last_delta += delta;
			}
			last_delta /= 3;
		}

		private function image_move_by_delta(delta:int):void
		{
			if (delta > 0 && (images[0] as MovieClip).y > 0)
			{
				delta -= int((images[0] as MovieClip).y / 50 * delta);
			}
			else if (delta < 0 && (images[images.length - 1] as MovieClip).y + (images[images.length - 1] as MovieClip).height < Data.height)
			{
				delta -= int((Data.height - (images[images.length - 1] as MovieClip).y - (images[images.length - 1] as MovieClip).height) / 50 * delta);
			}

			for (var cnt:int = 0; cnt < images.length; cnt++)
			{
				var img:MovieClip = images[cnt] as MovieClip;
				img.y += delta * main.main_stage.scaleY;
			}
		}

		private function on_frame(e:Event):void
		{
			if ((Math.abs(last_delta) < 0.9) || ((images[0] as MovieClip).y > 0) || ((images[images.length - 1] as MovieClip).y + (images[images.length - 1] as MovieClip).height < Data.height))
			{
				removeEventListener(Event.ENTER_FRAME, on_frame);
				last_delta = (images[0] as MovieClip).y > 0 ? -10 : 10;
				addEventListener(Event.ENTER_FRAME, on_frame_back_scroll);
				return;
			}

			image_move_by_delta(int(last_delta));
			last_delta = last_delta / 1.07;
		}

		private function on_frame_back_scroll(e:Event):void
		{
			if ((images[0] as MovieClip).y <= 0 && (images[images.length - 1] as MovieClip).y + (images[images.length - 1] as MovieClip).height >= Data.height)
			{
				removeEventListener(Event.ENTER_FRAME, on_frame_back_scroll);
				return;
			}

			image_move_by_delta(Math.ceil(last_delta));
			last_delta = last_delta / 1.02;
		}

		public function resize():void
		{
			var img:MovieClip;
			var cnt:int;

			if (Data.orientation == "landscape")
			{
				for (cnt = 0; cnt < images.length; cnt++)
				{
					img = images[cnt] as MovieClip;

					if (cnt % 2 == 0)
					{
						img.width = Data.width / 2 * scaleX;
						img.height = Data.width / 2 * image_height / image_width * scaleY;
						img.x = 0;
						img.y = img.height * cnt / 2;
					}
					else
					{
						img.width = Data.width / 2 * Data.scaleX;
						img.height = Data.width / 2 * image_height / image_width * Data.scaleY;
						img.x = img.width;
						img.y = img.height * (cnt - 1) / 2;
					}
				}
			}
			else
			{
				for (cnt = 0; cnt < images.length; cnt++)
				{
					img = images[cnt] as MovieClip;

					img.width = Data.width * Data.scaleX;
					img.height = Data.width * image_height / image_width * Data.scaleY;
					img.x = 0;
					img.y = img.height * cnt;
				}
			}

			move_to_last_played();
		}

		private function move_to_last_played():void
		{
			if (!(Data.last_played_level > 0))
			{
				return;
			}

			var _height:Number = (images[0] as MovieClip).height;
			var cnt:int = Data.last_played_level - 1;
			var delta:Number = _height * cnt;
			var delta_last:Number = _height * (images.length - 1);

			if (Data.orientation == "landscape")
			{
				if (cnt % 2 == 0)
				{
					delta = _height * cnt / 2;
				}
				else
				{
					delta = _height * (cnt - 1) / 2;
				}

				cnt = images.length - 1;
				if (cnt % 2 == 0)
				{
					delta_last = _height * cnt / 2;
				}
				else
				{
					delta_last = _height * (cnt - 1) / 2;
				}
			}

			if (delta_last - delta + _height < Data.height)
			{
				delta -= Data.height - (delta_last - delta + _height);
			}

			image_move_by_delta(-delta);
		}

	}

}
