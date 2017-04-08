package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.media.StageVideo;
	import flash.events.StageVideoEvent;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.sensors.Accelerometer;
	import flash.events.AccelerometerEvent;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.display.StageOrientation;
	import flash.events.StageOrientationEvent;
	import flash.filesystem.File;
	import flash.events.NetStatusEvent;

	public class Level extends MovieClip implements IRemoveListeners
	{
		private var ns:NetStream;
		private var time:Number = 0;
		private var sv:StageVideo;
		private var character:Character;
		private var stageVideoAvail:Boolean;
		private var video:Video;
		private var accl:Accelerometer;
		private var pause_btn:Pause;
		private var labels:Labels;
		private var click_layer:ClickedBackground;
		private var level:int;
		private var quality:String;
		private var back_btn:BackButton;
		private var is_paused:Boolean = false;
		private var pc:int = 0;
		private var pc1:int = 0;
		private var labels_jump:Array;
		private var click_me:DisplayObject;
		private var click_me_stop_time:Number;
		private var in_click_me:Boolean;
		private var in_click_me2:Boolean;
		private var in_click_me2_timer:Number = 0;
		private var radar:Radar;
		private var video_duration:Number = 10000;
		private var level_progress:LevelProgress;
		private var in_fa:Boolean = false;
		private var in_fa_start_time:Number;
		private var in_fa_duration:Number;
		private var in_fa_start_x:Number;
		private var in_fa_start_y:Number;
		private var in_fa_start_scaleX:Number;
		private var in_fa_start_scaleY:Number;
		private var character_generator:CharacterGenerator;

		public function Level(_level:int, _quality:String)
		{
			level = _level;
			quality = _quality;

			labels = new Labels(level);
			addChild(labels);

			Bottles.init();
			addChild(Bottles.current);
			BottlesGenerator.init(level);
			addChild(BottlesGenerator.current);

			character_generator = new CharacterGenerator(level);
			addChild(character_generator);

			radar = new Radar(level, character_generator);
			addChild(radar);

			character = new Character(character_generator);
			addChild(character);

			level_progress = new LevelProgress();
			addChild(level_progress);

			click_layer = new ClickedBackground();
			addChild(click_layer);

			back_btn = new BackButton();
			addChild(back_btn);

			pause_btn = new Pause();
			addChild(pause_btn);

			add_listeners();
			resize();

			labels_jump = Data.labels[level].concat();

			Data.last_played_level = level;
			Data.flush();
		}

		public function add_listeners():void
		{
			main.main_stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, init_video);

			click_layer.addEventListener(MouseEvent.MOUSE_DOWN, click);

			addEventListener(Event.ENTER_FRAME, update);

			pause_btn.addEventListener(MenuEvent.ON_PAUSE, pause);
			pause_btn.addEventListener(MenuEvent.ON_RESUME, resume);
			main.main_stage.addEventListener(KeyboardEvent.KEY_DOWN, kd);
		}

		public function remove_listeners():void
		{
			ns.removeEventListener(NetStatusEvent.NET_STATUS, statusChanged);
			ns.close();

			main.main_stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, init_video);
			click_layer.removeEventListener(MouseEvent.CLICK, click);

			removeEventListener(Event.ENTER_FRAME, update);

			if (sv)
			{
				sv.removeEventListener(StageVideoEvent.RENDER_STATE, onRender);
			}

			pause_btn.removeEventListener(MenuEvent.ON_PAUSE, pause);
			pause_btn.removeEventListener(MenuEvent.ON_RESUME, resume);

			pause_btn.remove_listeners();
		}

		public function resize():void
		{
			if (stageVideoAvail && sv)
			{
				ns.removeEventListener(NetStatusEvent.NET_STATUS, statusChanged);
				ns.close();
				ns.addEventListener(NetStatusEvent.NET_STATUS, statusChanged);
				sv = main.main_stage.stageVideos[0];
				sv.attachNetStream(ns);
				var fl:File = File.applicationStorageDirectory.resolvePath(quality + "/level_" + level + ".mp4");
				ns.play(fl.url);
			}
			else if (video)
			{
				video.width = Data.video_width;
				video.height = Data.video_height;
				video.y = int(Data.height / 2 - Data.video_height / 2);
			}

			character.resize();
			back_btn.resize();
			pause_btn.resize();
			Bottles.current.resize();
			BottlesGenerator.current.resize();
			radar.resize();
			level_progress.resize();

			click_layer.x = 0;
			click_layer.y = 0;
			click_layer.width = Data.width;
			click_layer.height = Data.height;
			character_generator.resize();
		}

		public function init_video(e:StageVideoAvailabilityEvent):void
		{
			stageVideoAvail = (e.availability == StageVideoAvailability.AVAILABLE);

			var nc:NetConnection = new NetConnection();
			nc.connect(null);

			ns = new NetStream(nc);
			ns.client = this;

			if (stageVideoAvail)
			{
				sv = main.main_stage.stageVideos[0];
				sv.addEventListener(StageVideoEvent.RENDER_STATE, onRender);
				sv.attachNetStream(ns);
			}
			else
			{
				video = new Video(Data.video_width, Data.video_height);
				video.y = int(Data.height / 2 - Data.video_height / 2);
				addChildAt(video, 0);
				video.attachNetStream(ns);
			}

			var fl:File = File.applicationStorageDirectory.resolvePath(quality + "/level_" + level + ".mp4");
			ns.play(fl.url);

			ns.addEventListener(NetStatusEvent.NET_STATUS, statusChanged);
		}

		public function onRender(e:StageVideoEvent):void
		{
			sv.viewPort = new Rectangle(0, Data.height / 2 - Data.video_height / 2, Data.video_width, Data.video_height);
		}

		private function click(e:Event):void
		{
			character.jump();
			if (in_click_me2 && in_click_me2_timer > 0)
			{
				if (time - in_click_me2_timer < 1)
				{
					click_me_stop_time = 0;
				}
				else
				{
					in_click_me2_timer = time;
				}
			}
			else if (in_click_me2)
			{
				in_click_me2_timer = time;
			}
			else if (in_click_me)
			{
				click_me_stop_time = 0;
			}
		}

		private function kd(e:KeyboardEvent):void
		{
			return;

			// z
			if (e.keyCode == 90)
			{
				pc1 -= 5;
				trace(pc1);
			}
			// x
			else if (e.keyCode == 88)
			{
				pc1 += 5;
				trace(pc1);
			}
		}

		private function update(e:Event):void
		{
			if (is_paused)
			{
				return;
			}

			time = ns.time + Data.add_time;

			update_jump(time);
			labels.update(time);
			Man.update_all(time);
			character.update(time);
			BottlesGenerator.current.update(time);
			radar.update(time);
			level_progress.update(time, video_duration);
			character_generator.update(time);
		}

		public function onXMPData(e:Object):void
		{
		}

		public function onMetaData(metadata:Object):void
		{
			video_duration = metadata.duration + 1;
		}

		private function pause(e:MenuEvent)
		{
			ns.pause();
			is_paused = true;
			character.stop_char();
		}

		private function resume(e:MenuEvent)
		{
			ns.resume();
			is_paused = false;
			character.start_char();
		}

		private function update_jump(_time:Number)
		{
			if (in_click_me && _time > click_me_stop_time)
			{
				removeChild(click_me);
				in_click_me = false;
			}

			if (in_fa)
			{
				character.x = in_fa_start_x - (_time - in_fa_start_time) * (in_fa_start_x - Data.width / 2 + Data.video_width * 0.2) / in_fa_duration;
				character.y = in_fa_start_y - (_time - in_fa_start_time) * (in_fa_start_y - Data.height / 2 - Data.video_height * 0.1) / in_fa_duration;
				character.scaleX = in_fa_start_scaleX - (_time - in_fa_start_time) * (in_fa_start_scaleX * 0.3) / in_fa_duration;
				character.scaleY = in_fa_start_scaleY - (_time - in_fa_start_time) * (in_fa_start_scaleY * 0.3) / in_fa_duration;
				return;
			}

			if (labels_jump.length <= 0)
			{
				return;
			}

			var label:Label = labels_jump[0] as Label;
			if (_time >= label.begin)
			{
				if (label.type == "j")
				{
					character.auto_jump(label.end);
				}
				else if (label.type == "md")
				{
					character.go_down(label.end, label.percent2);
				}
				else if (label.type == "mu")
				{
					character.go_up(label.end, label.percent2);
				}
				else if (label.type == "ms")
				{
					character.scale(label.percent2);
				}
				else if (label.type == "u")
				{
					character.up(label.percent2);
				}
				else if (label.type == "d")
				{
					character.down(label.percent2);
				}
				else if (label.type == "v")
				{
					character.velo();
				}
				else if (label.type == "c")
				{
					in_click_me = true;
					click_me = new ClickMe();
					addChild(click_me);
					click_me_stop_time = label.end;
				}
				else if (label.type == "c2")
				{
					in_click_me = true;
					in_click_me2 = true;
					click_me = new ClickMe2();
					addChild(click_me);
					click_me_stop_time = label.end;
				}
				else if (label.type == "fa")
				{
					in_fa = true;
					in_fa_start_time = _time;
					in_fa_duration = label.end - label.begin;
					in_fa_start_scaleX = character.scaleX;
					in_fa_start_scaleY = character.scaleY;
					in_fa_start_x = character.x;
					in_fa_start_y = character.start_y;
				}

				labels_jump.shift();
			}
		}

		private function statusChanged(stats:NetStatusEvent)
		{
			if (stats.info.code == 'NetStream.Play.Stop' && Bottles.current.count() > 0)
			{
				Data.levels_jumped[level - 1] = 1;
				Data.flush();

				ns.close();
				var ev:MenuEvent = new MenuEvent(MenuEvent.ON_SUCCESS, true);
				dispatchEvent(ev);
			}
		}

		// функция должна существовать, т.к. её вызывает плеер видео
		public function onPlayStatus(info:Object):void
		{
		}

	}

}