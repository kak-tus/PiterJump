package
{
	import flash.display.MovieClip;

	public class BottlesGenerator extends MovieClip
	{
		private var bottles:Array = new Array();
		public static var current:BottlesGenerator;
		private var labels:Array;
		private var pregenerated_bottle_times:Array = new Array();

		public static function init(_level:int)
		{
			current = new BottlesGenerator(_level);
		}

		public function BottlesGenerator(_level:int)
		{
			var count = Data.bottles[_level - 1];
			var count_curr = 0;

			labels = Data.labels[_level].concat();
			var label:Label = labels[labels.length - 1] as Label;
			var max_time:Number = label.begin;
			label = labels[0] as Label;
			var min_time:Number = label.begin;

			for (var i:int = 0; i < labels.length; i++)
			{
				label = labels[i] as Label;

				if (label.type == "m" || label.type == "mm")
				{
					count_curr++;
				}

				if (count_curr >= count)
				{
					count_curr = 0;
					var curr_time = 10;
					var rnd:Number = Math.random() * curr_time;
					var rnd_sign:Number = Math.random();

					if (label.begin + curr_time > max_time)
					{
						pregenerated_bottle_times.push(label.begin - rnd / 2);
					}
					else if (label.begin - curr_time < min_time)
					{
						pregenerated_bottle_times.push(label.begin + rnd / 2);
					}
					else if (rnd_sign < 0.5)
					{
						pregenerated_bottle_times.push(label.begin + rnd / 2);
					}
					else
					{
						pregenerated_bottle_times.push(label.begin - rnd / 2);
					}
				}
			}

			pregenerated_bottle_times.sort(Array.NUMERIC);
		}

		public function update(time:Number):void
		{
			if (pregenerated_bottle_times.length > 0)
			{
				if (time >= pregenerated_bottle_times[0])
				{
					add_bottle();
					pregenerated_bottle_times.shift();
				}
			}

			for (var i:int = 0; i < bottles.length; i++)
			{
				(bottles[i] as Bottle).x += 5 * Data.video_scaleX;
			}

			if (bottles.length > 0 && (bottles[0] as Bottle).x > Data.width)
			{
				removeChild(bottles.shift());
			}

			if (labels.length > 0)
			{
				var label:Label = labels[0] as Label;
				if (time >= label.begin)
				{
					if (label.type == "b")
					{
						add_bottle();
					}
					labels.shift();
				}
			}
		}

		public function collision(_x:int, _y:int, _width:int, _height:int):Boolean
		{
			var btl:Bottle;

			for (var i:int = 0; i < bottles.length; i++)
			{
				btl = bottles[i] as Bottle;

				if (Math.abs(_x - btl.x) <= (_width / 2 + btl.width / 2) && Math.abs(_y - btl.y) <= (_height / 2 + +btl.height / 2))
				{
					removeChild(btl);
					bottles.splice(i, 1);
					return true;
				}
			}

			return false;
		}

		public function resize():void
		{
			for (var i:int = 0; i < bottles.length; i++)
			{
				(bottles[i] as Bottle).resize();
			}
		}

		private function add_bottle():void
		{
			var btl:Bottle = new Bottle();
			btl.y = int(Math.random() * (Data.video_height - 30 * Data.scaleY - btl.height) + Data.height / 2 - Data.video_height / 2);
			addChild(btl);
			bottles.push(btl);
		}
	}

}