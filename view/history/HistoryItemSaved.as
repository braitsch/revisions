package view.history {

	import events.UIEvent;
	import model.vo.Commit;
	import view.ui.BasicButton;
	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _view			:HistoryItemSavedMC = new HistoryItemSavedMC();
		private var _bkgd			:Shape = new Shape();
		private var _buttons		:Array;
		private var _commit			:Commit;

		public function HistoryItemSaved(c:Commit)
		{
			super(_view);
			_commit = c;
			_view.time_txt.text = _commit.date;
			_view.details_txt.text = _commit.note;
			_view.num_txt.text = _commit.index.toString();
			addButtons();
			addChild(_bkgd);
			addChild(_view);
		}
		
		public function get commit():Commit { return _commit;}
		
		override public function resize(w:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginBitmapFill(new HistoryItemBkgd());
			_bkgd.graphics.drawRect(0, 0, w, 29);
			_bkgd.graphics.endFill();
			_view.buttons.x = w - 94;
			super.textMask.width = w - 105;
		}
		
	// private //			

		private function addButtons():void
		{
			_view.buttons.buttonMode = true;
			_buttons = [_view.buttons.revert, _view.buttons.download, _view.buttons.info];
			var l:Array = ['Revert', 'Download', 'Info'];
			for (var i:int = 0; i < 3; i++) {
				new BasicButton(_buttons[i], l[i]);
				_buttons[i].addEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch (e.currentTarget){
				case _buttons[0]	:
					dispatchEvent(new UIEvent(UIEvent.REVERT, _commit));
				break;	
				case _buttons[1] 	: 
					dispatchEvent(new UIEvent(UIEvent.DOWNLOAD, _commit));
				break;
				case _buttons[2]	:
					dispatchEvent(new UIEvent(UIEvent.SHOW_COMMIT, _commit));
				break;				
			}
		}		
		
	}
	
}
