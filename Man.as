package
{
	import flash.display.MovieClip;
	import flash.display.StageOrientation;
	import flash.events.StageOrientationEvent;

	public class Man extends MovieClip
	{
		public static var mans:Array = new Array();
		private var label:Label;
		private var start_time:Number = 0;
		private var body:MovieClip;

		public function Man(_label:Label, _level:int, _time:Number)
		{
			label = _label;
			start_time = _time;

			resize();
			body = getChildByName("collision_body") as MovieClip;

			mans.push(this);

			if (label.type == "mm" && label.percent2 > 0)
			{
				x = Data.width * label.percent2 / 100 + 0.1;
			}

			if (_level > 2)
			{
				var arrow:MovieClip = getChildByName("JumpArrow") as MovieClip;
				arrow.removeChild(arrow.getChildByName("jump") as MovieClip);
        arrow.removeChild(arrow.getChildByName("JumpLine") as MovieClip);
				removeChild(getChildByName("Shadow") as MovieClip);
			}
		}

		public static function update_all(time:Number):void
		{
			for each (var man:Man in mans)
			{
				man.update(time);
			}
		}

		private function resize():void
		{
			scaleX = Data.video_scaleX;
			scaleY = Data.video_scaleY;
			y = Data.height / 2 + Data.video_height / 2 - height - 30 * Data.video_scaleY;
		}

		private function update(time:Number):void
		{
			if (x > Data.video_width)
			{
				mans.splice(mans.indexOf(this), 1);
				this.parent.removeChild(this);
				return;
			}

			var w:Number;

			if (label.percent2 > 0 && x > Data.video_width * label.percent2 / 100)
			{
				w = Data.video_width * (100 - label.percent2) / 100;
				if (label.percent3 > 0)
				{
					w = Data.video_width * (label.percent3 - label.percent2) / 100;
				}

				x = Math.abs(time - start_time) * w / (label.end2 - label.begin2) * Data.video_scaleX;
			}
			else
			{
				w = Data.video_width;
				if (label.percent2 > 0)
				{
					w = Data.video_width * label.percent2 / 100;
				}

				x = Math.abs(time - start_time) * w / (label.end - label.begin - Data.diff_time);
			}
		}

		public function collision(_x:int, _y:int, _width:int, _height:int):Boolean
		{
			if (Math.abs(_x - (x + body.x * scaleX)) <= (body.width * scaleX / 2 + _width / 2) && Math.abs(_y - (y + body.y * scaleY)) <= (body.height * scaleY / 2 + _height / 2))
			{
				return true;
			}

			return false;
		}
	}

}