package view.history {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import view.graphics.Box;

	public class HistoryItemUnsaved extends HistoryItem {

		private var _bkgd			:Box;

		public function HistoryItemUnsaved()
		{
			drawBkgd();
			super.attachAvatar('');
			super.setText('Working Version - Unsaved', 'Right Now');
			addEventListener(MouseEvent.CLICK, onSaveSelection);
		}

		private function drawBkgd():void
		{
			_bkgd = new Box(500, 41, Box.WHITE);
			_bkgd.scalable = true;
			_bkgd.scaleOffset = 210;
			addChild(_bkgd);
		}
		
		private function onSaveSelection(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}
		
	}
	
}
