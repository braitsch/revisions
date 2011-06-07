package view.history {

	import events.UIEvent;
	import model.Commit;
	import com.greensock.TweenLite;
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
			_view.num_txt.text = _commit.index;
			_view.time_txt.text = _commit.date;
			_view.details_txt.text = _commit.note;
			addButtons();			addChild(_bkgd);
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
		}
		
	// private //			

		private function addButtons():void
		{
			_view.buttons.buttonMode = true;
			_buttons = [_view.buttons.revert, _view.buttons.download, _view.buttons.info];
			for (var i:int = 0; i < 3; i++) {
				_buttons[i].over.alpha = 0;
				_buttons[i].addEventListener(MouseEvent.CLICK, onButtonClick);
				_buttons[i].addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				_buttons[i].addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.getChildByName('over'), .3, {alpha:1});
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.getChildByName('over'), .7, {alpha:0});
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
//			trace("HistoryItem.onButtonClick(e)", e.currentTarget.name, _commit.sha1);
			switch (e.currentTarget.name){
				case 'info' 	: 
					dispatchEvent(new UIEvent(UIEvent.COMMIT_DETAILS, _commit));
				break;
//				case 'revert' 	: AppModel.proxies.checkout.checkout(_commit);	break;
//				case 'download' : AppModel.proxies.checkout.checkout(_commit);	break;
			}
		}		
		
	}
	
}
