package view.history {

	import flash.events.MouseEvent;
	import flash.display.Shape;

	public class HistoryItemUnsaved extends HistoryItem {

		private var _bkgd	:Shape = new Shape();
		private var _view	:HistoryItemUnsavedMC = new HistoryItemUnsavedMC();

		public function HistoryItemUnsaved()
		{
			super(_view);
			addChild(_bkgd);
			addChild(_view);
			_view.num_txt.text = 'XX';
			_view.time_txt.text = '- Right Now -';
			_view.details_txt.text = 'Working Version (Not Saved)';
			_view.save_btn.buttonMode = true;
			_view.save_btn.addEventListener(MouseEvent.CLICK, onSaveClick);
		}

		private function onSaveClick(e:MouseEvent):void
		{
			trace("HistoryItemUnsaved.onSaveClick(e) ------ saving commit");
//			AppModel.proxies.checkout.checkout(_commit);
		}
		
		override public function resize(w:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginFill(0xffffff);
			_bkgd.graphics.drawRect(0, 0, w, 29);
			_bkgd.graphics.endFill();
			_view.save_btn.x = w - 85;
		}		
		
	}
	
}
