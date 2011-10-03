package view.history {

	import events.UIEvent;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import flash.events.MouseEvent;

	public class HistoryItemUnsaved extends HistoryItem {

		private var _bkgd			:SolidBox = new SolidBox(Box.WHITE);

		public function HistoryItemUnsaved()
		{
			addChild(_bkgd);
			super.attachAvatar('');
			super.setText('Working Version - Unsaved', 'Right Now');
			addEventListener(MouseEvent.CLICK, onSaveSelection);
		}
		
		override public function setSize(w:uint, h:uint):void
		{
			_bkgd.draw(w, h);
		}		

		private function onSaveSelection(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}
		
	}
	
}
