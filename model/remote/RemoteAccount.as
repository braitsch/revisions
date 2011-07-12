package model.remote {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	public class RemoteAccount {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private var _type			:String;
		private var _login			:String;
		private var _pass			:String;
		private var _avatar			:Bitmap;
		private var _realName		:String;
		private var _location		:String;
		private var _repositories	:Array;

		public function RemoteAccount(o:Object)
		{
			_type = o.type;
			_login = o.login;
			_pass = o.pass;
			_realName = o.name;
			_location = o.location;
			loadAvatar(o.avatar_url);
		}

		public function get type():String { return _type; }
		public function get login():String { return _login; }
		public function get pass():String { return _pass; }
		public function get realName():String { return _realName; }
		public function get location():String { return _location; }
		public function get avatar():Bitmap { return _avatar; }
		
		public function get repositories():Array { return _repositories;}
		public function set repositories(a:Array):void {_repositories = a;}

		private function loadAvatar(url:String):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			ldr.load(new URLRequest(url));
		}

		private function onAvatarLoaded(e:Event):void
		{
			_avatar = e.currentTarget.content as Bitmap;
		}

	}
	
}
