package
{
	import flash.display.*;
	import flash.filters.*;

	public class LevelProgress extends MovieClip
	{
		private var time:Number = 0;
		private var duration:Number = 10000;
		private var line_1:Shape;
		private var start_pos:Number;
		private var stop_pos:Number;
		private var pos_y:Number;
		private var counter:int = 0;

		public function LevelProgress()
		{
			resize();
		}

		public function resize()
		{
			if (line_1)
			{
				removeChild(line_1);
			}

			start_pos = 10 * Data.scaleX;
			stop_pos = Data.width - 10 * Data.scaleX;
			pos_y = 2 * Data.video_scaleY;

			draw_line();
		}

		public function update(_time:Number, _duration:Number)
		{
			time = _time;
			duration = _duration;
			counter++;

			if (counter < 24)
			{
				return;
			}

			counter = 0;
			removeChild(line_1);
			draw_line();
		}

		private function draw_line()
		{
			var filter:GlowFilter = new GlowFilter(0, 1, 5, 5, 100, 1);
			var farr:Array = new Array();
			farr.push(filter);

			line_1 = new Shape();
			line_1.graphics.lineStyle(1, 0xFFFFFF);
			line_1.graphics.moveTo(start_pos, pos_y);
			line_1.graphics.lineTo(time * stop_pos / duration, pos_y);
			line_1.filters = farr;
			addChild(line_1);
		}
	}
}