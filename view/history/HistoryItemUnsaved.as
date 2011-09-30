package view.history {

	import events.UIEvent;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import flash.events.MouseEvent;

	public class HistoryItemUnsaved extends HistoryItem {

		private var _bkgd			:SolidBox = new SolidBox(Box.WHITE);

		public function HistoryItemUnsaved()
		{
			drawBkgd();
			super.attachAvatar('');
			super.setText('Working Version - Unsaved', 'Right Now');
			addEventListener(MouseEvent.CLICK, onSaveSelection);
		}

		private function drawBkgd():void
		{
			_bkgd.scalable = true;
			_bkgd.scaleOffset = 210;
			_bkgd.draw(500, 41);
			addChild(_bkgd);
		}
		
		private function onSaveSelection(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}
		
	}
	
}
