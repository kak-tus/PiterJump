package
{

	import flash.display.*;
	import flash.filters.*;

	public class Radar extends MovieClip
	{
		private const preview:int = 3;
		private var line_1:Shape;
		private var line_2:Shape;
		private var dots:Array = new Array();
		private var visible_dots:Array = new Array();
		private var start_pos:Number;
		private var stop_pos:Number;
		private var move_scale:Number;

		public function Radar(_level:int, character_generator:CharacterGenerator)
		{
			var dot:RadarDot;
			var move_time:Number;
			var start_time:Number;

			var labels:Array = Data.labels[_level].concat();
			for (var i:int = 0; i < labels.length; i++)
			{
				var lb:Label = labels[i] as Label;

				if (lb.type == "m")
				{

					move_time = lb.end - lb.begin - Data.diff_time;
					start_time = lb.begin - move_time * (preview - 1);
					dot = new RadarDot(start_time, move_time, lb.begin, lb.end);
					dot.y = 90 * Data.scaleY - dot.height / 2;
					dots.push(dot);
				}
			}

			for (i = 0; i < character_generator.positions.length; i++)
			{
				var begin:Number = character_generator.positions[i];
				var speed:Number = character_generator.speeds[i];
				var end:Number = Data.width / speed + begin;
				move_time = end - begin - Data.diff_time;
				start_time = begin - move_time * (preview - 1);
				dot = new RadarDot(start_time, move_time, lb.begin, lb.end);
				dot.y = 90 * Data.scaleY - dot.height / 2;
				dots.push(dot);
			}

			resize();
		}

		public function resize()
		{
			if (line_1)
			{
				removeChild(line_1);
				removeChild(line_2);
			}

			start_pos = 10 * Data.scaleX;
			stop_pos = Data.width - 10 * Data.scaleX;
			var pos_y:Number = Data.height / 2 + Data.video_height / 2 - 10 * Data.video_scaleY;

			var filter:GlowFilter = new GlowFilter(0, 1, 5, 5, 100, 1);
			var farr:Array = new Array();
			farr.push(filter);

			line_1 = new Shape();
			line_1.graphics.lineStyle(1, 0xFFFFFF);
			line_1.graphics.moveTo(start_pos, pos_y);
			line_1.graphics.lineTo(stop_pos, pos_y);
			line_1.filters = farr;
			addChild(line_1);

			line_2 = new Shape();
			line_2.graphics.lineStyle(1, 0xFFFFFF);
			line_2.graphics.moveTo((Data.width - 20 * Data.scaleX) * (1 - 1 / preview), pos_y - 5 * Data.scaleY);
			line_2.graphics.lineTo((Data.width - 20 * Data.scaleX) * (1 - 1 / preview), pos_y + 5 * Data.scaleY);
			line_2.filters = farr;
			addChild(line_2);

			var dot:RadarDot;
			var i:int;
			for (i = 0; i < dots.length; i++)
			{
				dot = dots[i] as RadarDot;
				dot.y = pos_y - dot.height / 2;
			}
			for (i = 0; i < visible_dots.length; i++)
			{
				dot = visible_dots[i] as RadarDot;
				dot.y = pos_y - dot.height / 2;
			}

			move_scale = (Data.width - 20 * Data.scaleX) / Data.video_width;
		}

		public function update(time:Number)
		{
			var dot:RadarDot;
			var i:int;
			for (i = 0; i < dots.length; )
			{
				dot = dots[i] as RadarDot;

				if (time > dot.start_time)
				{
					addChild(dot);
					visible_dots.push(dot);
					dots.splice(i, 1);
				}
				else
				{
					i++;
				}
			}

			for (i = 0; i < visible_dots.length; )
			{
				dot = visible_dots[i] as RadarDot;

				if (dot.x > stop_pos)
				{
					removeChild(dot);
					visible_dots.splice(i, 1);
				}
				else
				{
					dot.x = start_pos + Math.abs(time - dot.start_time) * Data.video_width / dot.move_time / preview * move_scale;
					i++;
				}
			}
		}
	}

}
