package model.vo {

	import com.adobe.crypto.MD5;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Avatar extends Sprite {

		private var _size	:uint = 30;
		private var _loader	:Loader = new Loader();

		public function Avatar(email:String, isURL:Boolean = false)
		{
			drawBackground();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
			_loader.load(new URLRequest(isURL ? email : 'http://www.gravatar.com/avatar/'+MD5.hash(email)+'?s='+_size));
		}
		
		private function drawBackground():void
		{
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, _size, _size);
			graphics.endFill();			
		}

		private function onAvatarLoaded(e:Event):void
		{
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.width = b.height = _size;
			addChild(b);
		}	
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------Avatar.onAvatarFailure(e)--------");
		}				
		
	}
	
}
