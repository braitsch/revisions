package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	public class RemoteAccount extends EventDispatcher {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private var _type			:String;
		private var _repos			:Array;
		private var _name			:String;	// user's full name //
		private var _location		:String;	// user's location //
		private var _avatar			:Sprite;

		public function RemoteAccount(o:Object)
		{
			_type = o.type;
			_repos = o.repos;
			_name = o.name;
			_location = o.location;
			getAccountAvatar(o.avatar_url);
		}
		
		public function purge():void
		{
			_repos = null; _avatar = null;
			_name = _type = _location = null;
		}

		public function get type()			:String { return _type; 		}
		public function get repos()			:Array  { return _repos;		}
		public function get name()			:String { return _name; 		}
		public function get avatar()		:Sprite { return _avatar;		}
		public function get location()		:String { return _location; 	}

		private function getAccountAvatar(url:String):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			ldr.load(new URLRequest(url));
		}

		private function onAvatarLoaded(e:Event):void
		{
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.x = b.y = 2;
				b.width = b.height = 26;
			_avatar = new Sprite();
			_avatar.addChild(b);
			_avatar.graphics.beginFill(0x959595);
			_avatar.graphics.drawRect(0, 0, 30, 30);
			_avatar.graphics.endFill();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_READY, this));
		}

	}
	
}
