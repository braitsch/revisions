package view.history {

	import events.UIEvent;
	import model.vo.Commit;
	import view.ui.SmartButton;
	import view.ui.Tooltip;
	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _view			:HistoryItemSavedMC = new HistoryItemSavedMC();
		private var _bkgd			:Shape = new Shape();
		private var _buttons		:Array;
		private var _commit			:Commit;

		public function HistoryItemSaved(c:Commit, n:uint)
		{
			super(_view);
			_commit = c;
			_view.num_txt.text = n.toString();
			_view.time_txt.text = _commit.date;
			_view.details_txt.text = _commit.note;
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
			for (var i:int = 0; i < 3; i++) {
				var b:SmartButton = new SmartButton(_buttons[i], new Tooltip('bwah'));
				b.view.addEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch (e.currentTarget.name){
				case 'revert'	:
					dispatchEvent(new UIEvent(UIEvent.REVERT, _commit));
				break;	
				case 'info' 	: 
					dispatchEvent(new UIEvent(UIEvent.COMMIT_DETAILS, _commit));
				break;
				case 'download'	:
					dispatchEvent(new UIEvent(UIEvent.DOWNLOAD, _commit));
				break;				
			}
		}		
		
	}
	
}
