package view.frame {

	import view.graphics.SolidBox;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HeaderDragArea extends Sprite {

	private static var _box:SolidBox = new SolidBox(0xff0000);

		public function HeaderDragArea()
		{
			alpha = 0;
			addChild(_box);
			addEventListener(MouseEvent.MOUSE_DOWN, startMove);			
		}
		
		public function draw(w:uint, h:uint):void
		{
			_box.draw(w, h);
		}
		
		private function startMove(e:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}		
		
	}
	
}
