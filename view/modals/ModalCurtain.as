package view.modals {

	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class ModalCurtain extends Sprite {

		public function ModalCurtain()
		{
			alpha = 0;
			mouseEnabled = false;					
		}
		
		public function resize(w:uint, h:uint):void
		{
			graphics.clear();	
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();			
		}

		public function show():void
		{
			mouseEnabled = true;
			TweenLite.to(this, .5, {alpha:1});
		}

		public function hide():void
		{
			mouseEnabled = false;
			TweenLite.to(this, .5, {alpha:0});
		}
		
	}
	
}
