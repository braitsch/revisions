package model.remote {

	import com.adobe.crypto.MD5;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class Account extends EventDispatcher {
		
		public static const GITHUB		:String = 'GitHub';
		public static const BEANSTALK	:String = 'Beanstalk';
		
		private var _type				:String;
		private var _user				:String;
		private var _pass				:String;
		private var _sshKeyId			:uint;
		
		private var _avatar				:Sprite = new Sprite();
		private var _fullName			:String;
		private var _location			:String;
		private var _repositories		:Array;

		public function Account(o:Object)
		{
			_type = o.type;
			_user = o.user;
			_pass = o.pass;
			_sshKeyId = o.sshKeyId;
		}
		
		public function set loginData(o:Object):void
		{
			_fullName = o.name;
			_location = o.location;
			loadAvatar(o.avatar_url || 'http://www.gravatar.com/avatar/'+MD5.hash(o.email)+'?s=26');
		}

		public function get type()			:String 	{ return _type; 		}
		public function get user()			:String 	{ return _user; 		}
		public function get pass()			:String 	{ return _pass; 		}
		
		public function get avatar()		:Sprite 	{ return _avatar; 		}
		public function get fullName()		:String 	{ return _fullName; 	}
		public function get location()		:String 	{ return _location; 	}
		
		public function set repositories(a:Array):void 	{ _repositories = a;	}
		public function get repositories()	:Array  	{ return _repositories;	}
		
		public function set sshKeyId(n:uint):void 		{ _sshKeyId = n; 		}
		public function get sshKeyId()		:uint 		{ return _sshKeyId;		}
		
		private function loadAvatar(url:String):void
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
			_avatar.addChild(b);
			_avatar.graphics.beginFill(0x959595);
			_avatar.graphics.drawRect(0, 0, 30, 30);
			_avatar.graphics.endFill();
		}
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------RemoteAccount.onAvatarFailure(e)--------");
		}			

	}
	
}
