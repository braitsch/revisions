package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	public class Account extends EventDispatcher {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private var _type			:String;
		private var _user			:String;
		private var _pass			:String;
		private var _primary		:uint;
		private var _sshKeyId		:uint;
		
		private var _name			:String;	// user's full name //
		private var _location		:String;	// user's location //
		private var _avatar			:Sprite;
		private var _repositories	:Array;

		public function Account(o:Object)
		{
			_type = o.type;
			_user = o.user;
			_pass = o.pass;
			_sshKeyId = o.sshKeyId;
		}
		
		public function set primary(n:uint):void
		{
			_primary = n;
		}
		
		public function get sshKeyId():uint
		{
			return _sshKeyId;
		}	
		
		public function set sshKeyId(n:uint):void
		{
			_sshKeyId = n;
		}		
		
		public function set loginData(o:Object):void
		{
			_name = o.name;
			_location = o.location;
			getAccountAvatar(o.avatar_url);
		}
		
		public function set repositories(a:Array):void
		{
			_repositories = a;
			if (_avatar) dispatchAccountReady();
		}

		public function get type()			:String 	{ return _type; 		}
		public function get user()			:String 	{ return _user; 		}
		public function get pass()			:String 	{ return _pass; 		}
		public function get primary()		:uint 		{ return _primary; 		}
		
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
			if (_repositories) dispatchAccountReady();
		}
		
		private function dispatchAccountReady():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_READY, this));
		}		
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			if (_repositories) dispatchAccountReady();
			trace("--------RemoteAccount.onAvatarFailure(e)--------");
		}

	}
	
}
