package
{

	import flash.display.MovieClip;

	public class CharacterBack extends MovieClip
	{
		public var start_time:Number;
		public var speed:Number;
    public var collision_body:MovieClip;

		public function CharacterBack(_start_time:Number, _speed:Number)
		{
			start_time = _start_time;
			speed = _speed;
      collision_body = getChildByName("collision_body") as MovieClip;
		}
	}

}
