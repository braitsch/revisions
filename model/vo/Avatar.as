package model.vo {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Avatar extends Sprite {

		private var _loader:Loader = new Loader();

		public function Avatar(url:String)
		{
			drawBackground();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
			_loader.load(new URLRequest(url));
		}
		
		private function drawBackground():void
		{
			graphics.beginBitmapFill(new DkGreyPattern());
			graphics.drawRect(0, 0, 30, 30);
			graphics.endFill();			
		}

		private function onAvatarLoaded(e:Event):void
		{
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.x = b.y = 2;
				b.width = b.height = 26;
			addChild(b);
		}	
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------Avatar.onAvatarFailure(e)--------");
		}				
		
	}
	
}
