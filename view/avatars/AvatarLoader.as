package view.avatars {

	import events.AppEvent;
	import flash.display.BitmapData;
	import com.adobe.crypto.MD5;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class AvatarLoader extends Sprite {

		private var _id		:String;
		private var _size	:uint = 30;
		private var _bmd	:BitmapData;
		private var _loader	:Loader = new Loader();

		public function AvatarLoader(id:String)
		{
			if (id){
				requestAvatar(id);
			}	else{
				setAvatarToDefault();
			}
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function getImage():Bitmap
		{
			if (_bmd == null){
				return null;
			}	else{
				var b:Bitmap = new Bitmap(_bmd);
					b.smoothing = true;
					b.width = b.height = _size;
				return b;
			}
		}
		
		private function requestAvatar(id:String):void
		{
			_id = id;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
			_loader.load(new URLRequest(_id.indexOf('https://') == -1 ? encodeEmail(id) : id));			
		}
		
		private function encodeEmail(email:String):String
		{
			return 'http://www.gravatar.com/avatar/'+MD5.hash(email)+'?s='+_size+'&d=http://revisions-app.com/img/rev-icon-30.png';			
		}
		
		private function onAvatarLoaded(e:Event):void
		{
			_bmd = e.currentTarget.content.bitmapData;
			dispatchEvent(new AppEvent(AppEvent.AVATAR_LOADED));
		}	
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			setAvatarToDefault();
		}
		
		private function setAvatarToDefault():void
		{
			_bmd = new UserIcon30();
			dispatchEvent(new AppEvent(AppEvent.AVATAR_LOADED));						
		}
		
	}
	
}
