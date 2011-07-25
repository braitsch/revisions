package model.remote {

	import events.AppEvent;
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
		private var _avatar			:Sprite;
		private var _realName		:String;
		private var _location		:String;
		private var _repositories	:Array;

		public function RemoteAccount(o:Object)
		{
			_type = o.type;
			_realName = o.name;
			_location = o.location;
			loadAvatar(o.avatar_url);
		}

		public function get type():String { return _type; }
		public function get avatar():Sprite { return _avatar; }
		public function get realName():String { return _realName; }
		public function get location():String { return _location; }
		
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
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.x = b.y = 2;
				b.width = b.height = 26;
			_avatar = new Sprite();
			_avatar.addChild(b);
			_avatar.graphics.beginFill(0x959595);
			_avatar.graphics.drawRect(0, 0, 30, 30);
			_avatar.graphics.endFill();
			dispatchEvent(new AppEvent(AppEvent.AVATAR_LOADED));
		}

	}
	
}
