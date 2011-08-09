package model.remote {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	public class RemoteAccount extends EventDispatcher {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private var _type			:String;
		private var _user			:String;
		private var _pass			:String;
		private var _main			:Boolean;
		
		private var _name			:String;	// user's full name //
		private var _location		:String;	// user's location //
		private var _avatar			:Sprite;
		private var _repositories	:Array;

		public function RemoteAccount(o:Object)
		{
			_type = o.type;
			_user = o.user;
			_pass = o.pass;
			_main = o.main;
		}
		
		public function set loginData(o:Object):void
		{
			_name = o.name;
			_location = o.location;
			getAccountAvatar(o.avatar_url);
			trace("RemoteAccount.loginData(o)");
		}
		
		public function set repositories(a:Array):void
		{
			_repositories = a;
			trace('_repositories: ' + (_repositories));
		}

		public function get type()			:String 	{ return _type; 		}
		public function get user()			:String 	{ return _user; 		}		
		public function get pass()			:String 	{ return _pass; 		}		
		public function get main()			:Boolean 	{ return _main; 		}		
		public function get name()			:String 	{ return _name; 		}
		public function get location()		:String 	{ return _location; 	}
		public function get avatar()		:Sprite 	{ return _avatar;		}
		public function get repositories()	:Array  	{ return _repositories;	}

		private function getAccountAvatar(url:String):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
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
		//	AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_READY, this));
		}
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------RemoteAccount.onAvatarFailure(e)--------");
		//	AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_READY, this));
		}		

	}
	
}
