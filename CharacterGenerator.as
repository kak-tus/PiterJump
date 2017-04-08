package
{
	import flash.display.MovieClip;

	public class CharacterGenerator extends MovieClip
	{
		public var positions:Array = new Array();
		public var speeds:Array = new Array();
		private var characters:Array = new Array();
		private const generate_time:Number = 12;

		public function CharacterGenerator(_level:int)
		{
			if (_level < 4 || _level == 32)
			{
				return;
			}

			var labels:Array = Data.labels[_level].concat();
			var last_time:Number = 0;

			for (var i:int = 0; i < labels.length; i++)
			{
				var label:Label = labels[i];

				if (Math.abs(label.begin - last_time) >= generate_time)
				{
					generate(last_time, label.begin);
				}

				last_time = label.begin;
			}
		}

		private function generate(begin:Number, end:Number)
		{
			var cnt:int = int(Math.abs(end - begin) / generate_time);
			var period:Number = Math.abs(end - begin) / (cnt + 1);

			for (var i:int = 1; i <= cnt; i++)
			{
				var sign:Number = Math.random();
				var pos = begin + period * i;

				if (sign < 0.5)
				{
					pos -= Math.random() * 2;
				}
				else
				{
					pos += Math.random() * 2;
				}

				positions.push(pos);

				var speed:Number = (Math.random() * 700 + 600) * Data.video_scaleX;
				speeds.push(speed);
			}
		}

		public function update(time:Number)
		{
			var char:CharacterBack;

			if (positions.length > 0)
			{
				var pos:Number = positions[0];

				if (time >= pos)
				{
					var speed:Number = speeds[0];
					char = new CharacterBack(pos, speed);
					char.scaleX = Data.video_scaleX;
					char.scaleY = Data.video_scaleY;
					char.x = 0;
					char.y = Data.height / 2 + Data.video_height / 2 - char.height - 30 * Data.video_scaleY;

					characters.push(char);
					addChild(char);

					positions.shift();
					speeds.shift();
				}
			}

			for (var i:int = 0; i < characters.length; i++)
			{
				char = characters[i] as CharacterBack;
				char.x = (time - char.start_time) * char.speed;
			}

			if (characters.length > 0)
			{
				char = characters[0] as CharacterBack;
				if (char.x > Data.width + 100)
				{
					removeChild(char);
					characters.shift();
				}
			}
		}

		public function resize()
		{
			var char:CharacterBack;

			for (var i:int = 0; i < characters.length; i++)
			{
				char = characters[i] as CharacterBack;
				char.scaleX = Data.video_scaleX;
				char.scaleY = Data.video_scaleY;
				char.y = Data.height / 2 + Data.video_height / 2 - char.height - 30 * Data.video_scaleY;
			}
		}

		public function collision(_x:Number, _y:Number, _width:Number, _height:Number)
		{
			var char:CharacterBack;
			var body:MovieClip;

			for (var i:int = 0; i < characters.length; i++)
			{
				char = characters[i] as CharacterBack;
				body = char.collision_body;

				if (Math.abs(_x - (char.x + body.x * scaleX)) <= (body.width * scaleX / 2 + _width / 2) && Math.abs(_y - (char.y + body.y * scaleY)) <= (body.height * scaleY / 2 + _height / 2))
				{
					return true;
				}

				return false;
			}

		}
	}
}