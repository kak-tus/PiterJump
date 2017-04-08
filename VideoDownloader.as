package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.net.SharedObject;
	import flash.net.*;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.events.OutputProgressEvent;
	
	public class VideoDownloader extends MovieClip
	{
		private var stream:URLStream;
		private var fileStream:FileStream;
		private var level:int;
		private var current_level:int;
		private var quality:String;
		private var listener:Button;
		private var bytes_loaded:uint = 0;
		
		public function VideoDownloader(_level:int, _quality:String, _listener:Button)
		{
			level = _level;
			quality = _quality;
			listener = _listener;
			
			listener.start_download();
			set_button(true);
			
			current_level = level;
			if (level == 0)
			{
				found_next_level();
			}
			
			set_loader();
		}
		
		private function set_button(_start:Boolean = false)
		{
			var btn_txt:String = "button_download";
			if (_start)
			{
				btn_txt += "ing";
			}
			if (level == 0)
			{
				btn_txt += "_all";
			}
			if (quality == "hq")
			{
				btn_txt += "_hq";
			}
			else
			{
				btn_txt += "_lq";
			}
			listener.set_text(btn_txt);
		}
		
		public function stop_download()
		{
			stream.close();
			fileStream.close();
			
			remove_listeners();
			set_button();
		}
		
		private function set_loader():void
		{
			stream = new URLStream();
			fileStream = new FileStream();
			
			var request:URLRequest = new URLRequest("http://pj.xvostovnet.ru/video/" + quality + "/level_" + current_level + ".dat");
			
			add_listeners();
			
			var file:File = File.applicationStorageDirectory.resolvePath(quality + "/level_" + current_level + ".mp4");
			fileStream.openAsync(file, FileMode.WRITE);
			
			try
			{
				stream.load(request);
			}
			catch (error:Error)
			{
				download_fail();
			}
		}
		
		private function add_listeners():void
		{
			stream.addEventListener(Event.COMPLETE, complete);
			stream.addEventListener(ProgressEvent.PROGRESS, progress);
			stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, filestream_error);
		}
		
		public function remove_listeners():void
		{
			stream.removeEventListener(Event.COMPLETE, complete);
			stream.removeEventListener(ProgressEvent.PROGRESS, progress);
			stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			fileStream.removeEventListener(IOErrorEvent.IO_ERROR, filestream_error);
		}
		
		private function complete(event:Event):void
		{
			var data:ByteArray = new ByteArray();
			stream.readBytes(data, 0, stream.bytesAvailable);
			fileStream.writeBytes(data, 0, data.length);
			stream.close();
			fileStream.close();
			
			if (quality == "hq")
			{
				Data.levels_downloaded_hq[current_level - 1] = 1;
			}
			else
			{
				Data.levels_downloaded_lq[current_level - 1] = 1;
			}
			Data.flush();
			
			if (level == 0)
			{
				found_next_level();
				if (current_level == 0)
				{
					done_download();
				}
				else
				{
					set_loader();
				}
			}
			else
			{
				done_download();
			}
		}
		
		private function done_download():void
		{
			listener.stop_download();
			remove_listeners();
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_DOWNLOADED, true);
			dispatchEvent(ev);
		}
		
		private function progress(e:ProgressEvent):void
		{
			if (stream.bytesAvailable > 51200)
			{
				var data:ByteArray = new ByteArray();
				stream.readBytes(data, 0, stream.bytesAvailable);
				fileStream.writeBytes(data, 0, data.length);
			}
			
			if (level == 0)
			{
				var total:uint;
				if (quality == "hq")
				{
					total = Data.video_size_all_hq;
				}
				else
				{
					total = Data.video_size_all_lq;
				}
				
				listener.download_progress(bytes_loaded + e.bytesLoaded, total);
			}
			else
			{
				listener.download_progress(e.bytesLoaded, e.bytesTotal);
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			download_fail();
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			download_fail();
		}
		
		private function found_next_level():void
		{
			current_level = 0;
			bytes_loaded = 0;
			
			for (var i:int = 1; i <= Data.levels_count; i++)
			{
				if (quality == "hq" && Data.levels_downloaded_hq[i - 1] == 0)
				{
					current_level = i;
					break;
				}
				else if (quality == "lq" && Data.levels_downloaded_lq[i - 1] == 0)
				{
					current_level = i;
					break;
				}
				
				if (quality == "hq")
				{
					bytes_loaded += Data.video_size_hq[i - 1];
				}
				else
				{
					bytes_loaded += Data.video_size_lq[i - 1];
				}
			}
		}
		
		private function filestream_error(e:Event)
		{
			download_fail();
		}
		
		private function download_fail():void
		{
			listener.stop_download();
			remove_listeners();
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_DOWNLOADERROR, true);
			dispatchEvent(ev);
		}
	}

}