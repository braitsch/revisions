package view.history {

	import events.UIEvent;
	import view.Box;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryItemUnsaved extends Sprite {

		private var _bkgd			:Box;

		public function HistoryItemUnsaved()
		{
			drawShapes();
			addTextDetails();
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onSaveSelection);
		}

		private function drawShapes():void
		{
			_bkgd = new Box(500, 40, Box.SOLID);
			_bkgd.scalable = true;
			_bkgd.scaleOffset = 210;
			addChild(_bkgd);
		}
		
		private function addTextDetails():void
		{
			
		}

		private function onSaveSelection(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}
		
	}
	
}
