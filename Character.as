package
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageOrientation;
	import flash.events.StageOrientationEvent;

	public class Character extends MovieClip
	{
		private var jump_level:int = 0;
		public var start_y:Number;
		private var start_time:Number;
		private var base_jump_speed:Number;
		private var speed:Number;
		private const g:Number = 9.81;
		private var start_y_2:Number;
		private var in_auto_jump:Boolean;
		private var auto_jump_stop_time:Number;
		private var auto_fall_time:Number;
		private var in_go_up_down:Boolean;
		private var go_up_down_val:Number;
		private var go_up_down_stop_time:Number;
		private var go_up_down_start_y:Number;
		private var character_generator:CharacterGenerator;

		public function Character(_character_generator:CharacterGenerator)
		{
			character_generator = _character_generator;
			stop();
			character.gotoAndStop("walk");

			addEventListener(Event.ENTER_FRAME, on_frame);

			resize();
		}

		public function resize():void
		{
			scaleX = Data.video_scaleX;
			scaleY = Data.video_scaleY;
			x = Data.width - width - 30 * Data.video_scaleX;
			y = Data.height / 2 + Data.video_height / 2 - height - 30 * Data.video_scaleY;
			start_y = y;
			base_jump_speed = Math.sqrt(2 * g * (start_y - Data.height / 2 + Data.video_height / 2 + height / 2) / (height / scaleY));
		}

		public function jump():void
		{
			if (in_auto_jump)
			{
				return;
			}

			// прыгаем два раза
			if (jump_level >= 2)
			{
				return;
			}

			jump_level++;

			if (jump_level == 1)
			{
				start_time = 0;
				speed = base_jump_speed;
				stop_char();
				start_y_2 = 0;
			}
			else
			{
				start_time = 0;
				speed = Math.sqrt(2 * g * (start_y - Data.height / 2 + Data.video_height / 2 + height * 2 - (start_y - y)) / (height / scaleY));
				start_y_2 = y
			}
		}

		public function update(time:Number):void
		{
			if (in_go_up_down)
			{
				start_y += go_up_down_val;
				y += go_up_down_val;

				if (time > go_up_down_stop_time || (go_up_down_val < 0 && go_up_down_start_y > start_y))
				{
					in_go_up_down = false;
				}
			}

			if (jump_level > 0 || in_auto_jump)
			{
				start_time += 1 / 30;

				if (jump_level == 1)
				{
					y = start_y - (speed * start_time - (g * Math.pow(start_time, 2)) / 2) * (height / scaleY);
				}
				else if (jump_level == 2)
				{
					y = start_y_2 - (speed * start_time - (g * Math.pow(start_time, 2)) / 2) * (height / scaleY);
				}
				else if (in_auto_jump)
				{
					var new_y = start_y - (speed * start_time - (g * Math.pow(start_time, 2)) / 2) * (height / scaleY);

					if (new_y < y)
					{
						y = new_y;
						auto_fall_time = start_time;
					}
					else if (time >= auto_jump_stop_time - auto_fall_time)
					{
						start_time = auto_fall_time;
						jump_level = 1;
					}
					else if (time >= auto_jump_stop_time)
					{
						start_time = 1;
						jump_level = 1;
					}
				}

				if (y > start_y)
				{
					jump_level = 0;
					y = start_y;
					start_char();
					in_auto_jump = false;
				}
			}

			collision();

			if (BottlesGenerator.current.collision(x, y, width, height))
			{
				Bottles.current.add();
			}
		}

		private function collision():void
		{
			if (currentFrameLabel != "run")
			{
				return;
			}

			var ev:MenuEvent;
			for each (var man:Man in Man.mans)
			{
				if (man.collision(x, y, width, height))
				{
					gotoAndPlay("fall");
					Bottles.current.remove(1);

					if (Bottles.current.count() <= 0)
					{
						ev = new MenuEvent(MenuEvent.ON_FAIL, true);
						dispatchEvent(ev);
					}

					return;
				}
			}

			if (character_generator.collision(x, y, width, height))
			{
				gotoAndPlay("fall");
				Bottles.current.remove(1);

				if (Bottles.current.count() <= 0)
				{
					ev = new MenuEvent(MenuEvent.ON_FAIL, true);
					dispatchEvent(ev);
				}

				return;
			}
		}

		private function on_frame(e:Event):void
		{
			if (currentFrameLabel == "fall_stop")
			{
				gotoAndStop("run");
			}
		}

		public function stop_char():void
		{
			character.char.stop();
			if (character.char.char)
			{
				character.char.char.stop();
				character.char.char.l1.stop();
				character.char.char.l2.stop();
				character.char.w1.stop();
				character.char.w2.stop();
			}
		}

		public function start_char():void
		{
			character.char.play();
			if (character.char.char)
			{
				character.char.char.play();
				character.char.char.l1.play();
				character.char.char.l2.play();
				character.char.w1.play();
				character.char.w2.play();
			}
		}

		public function auto_jump(_stop_time:Number):void
		{
			if (in_auto_jump)
			{
				return;
			}

			in_auto_jump = true;
			jump_level = 0;

			auto_jump_stop_time = _stop_time;

			start_time = 0;
			speed = base_jump_speed * 1.1;
			stop_char();
			start_y_2 = 0;
		}

		public function go_down(_stop_time:Number, _value:Number):void
		{
			in_go_up_down = true;
			go_up_down_val = _value * (height / Data.video_scaleY);
			go_up_down_stop_time = _stop_time;

			if (_value > 0)
			{
				if (jump_level > 0)
				{
					go_up_down_start_y = start_y;
				}
				else
				{
					go_up_down_start_y = y;
				}
			}
		}

		public function go_up(_stop_time:Number, _value:Number):void
		{
			go_down(_stop_time, -_value);
		}

		public function scale(_value:Number):void
		{
			scaleX = scaleX * _value / 100;
			scaleY = scaleY * _value / 100;
		}

		public function up(_value:Number):void
		{
			y -= Data.height * _value / 100;
			start_y = y;
		}

		public function down(_value:Number):void
		{
			y += Data.height * _value / 100;
			start_y = y;
		}

		public function velo():void
		{
			character.gotoAndStop("velo");
			x = Data.width - width - 30 * Data.video_scaleX;
		}

	}

}
