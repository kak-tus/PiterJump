package
{

	import flash.display.MovieClip;

	public class RadarDot extends MovieClip
	{
		public var start_time:Number;
		public var move_time:Number;
		public var visible_time:Number;
		public var stop_time:Number;

		public function RadarDot(_start_time:Number, _move_time:Number, _visible_time:Number, _stop_time:Number)
		{
			start_time = _start_time;
			move_time = _move_time;
			visible_time = _visible_time;
			stop_time = _stop_time;
		}
	}

}
