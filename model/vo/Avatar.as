package model.vo {

	import com.adobe.crypto.MD5;
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Avatar extends Sprite {

		private var _size	:uint = 30;
		private var _stroke	:Shape = new Shape();	
		private var _loader	:Loader = new Loader();

		public function Avatar(url:String)
		{
			drawStroke();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
			if (url.indexOf('https://') == -1) url = encodeURL(url);
			_loader.load(new URLRequest(url));
		}
		
		private function encodeURL(email:String):String
		{
			return 'http://www.gravatar.com/avatar/'+MD5.hash(email)+'?s='+_size+'&d=http://revisions-app.com/img/rev-icon-30.png';			
		}
		
		private function drawStroke():void
		{
			_stroke.graphics.lineStyle(1, 0xDADADA, 1, true, LineScaleMode.NONE , CapsStyle.NONE, JointStyle.MITER);
			_stroke.graphics.drawRect(0, 0, _size-1, _size-1);
			addChild(_stroke);
		}

		private function onAvatarLoaded(e:Event):void
		{
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.width = b.height = _size;
			addChildAt(b, 0);
		}	
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------Avatar.onAvatarFailure(e)--------");
		}				
		
	}
	
}
