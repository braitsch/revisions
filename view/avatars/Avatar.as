package view.avatars {

	import flash.display.Bitmap;
	import events.AppEvent;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Avatar extends Sprite {

		private var _loader	:AvatarLoader;
		private var _stroke	:Shape = new Shape();

		public function Avatar(x:AvatarLoader)
		{
			_loader = x;
			drawStroke();
			attachAvatar();
		}

		private function attachAvatar():void
		{
			var n:Bitmap = _loader.getImage(); 
			if (n){
				addChild(n);
			}	else{
				_loader.addEventListener(AppEvent.AVATAR_LOADED, onAvatarLoaded);
			}
		}

		private function onAvatarLoaded(e:AppEvent):void
		{
			addChild(_loader.getImage());
		}
		
		private function drawStroke():void
		{
			_stroke.graphics.lineStyle(1, 0xDADADA, 1, true, LineScaleMode.NONE , CapsStyle.NONE, JointStyle.MITER);
			_stroke.graphics.drawRect(0, 0, 29, 29);
			addChild(_stroke);
		}
				
	}
	
}
