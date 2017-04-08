package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;

	public class Labels extends MovieClip
	{
		private var labels:Array;
		private var level:int;

		public function Labels(_level:int)
		{
			labels = Data.labels[_level].concat();
			level = _level;
		}

		public function update(time:Number)
		{
			if (labels.length <= 0)
			{
				return;
			}

			var label:Label = labels[0] as Label;
			if (time >= label.begin)
			{
				if (label.type == "m" || label.type == "mm")
				{
					var new_man:Man = new Man(label, level, time);
					addChild(new_man);
				}

				labels.shift();
			}
		}

	}
}