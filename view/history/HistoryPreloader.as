package view.history {

	import flash.display.Sprite;

	public class HistoryPreloader extends Sprite {

		public function HistoryPreloader()
		{
			this.visible = false;
			graphics.beginFill(0xff0000);
			graphics.drawCircle(0, 0, 50);
			graphics.endFill();			
		}

		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
	}
	
}
