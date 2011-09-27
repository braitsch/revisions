package view.history {

	import model.vo.Commit;
	import view.Box;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _bkgd			:Box;
		private var _ptrn			:Box;
		private var _commit			:Commit;

		public function HistoryItemSaved(c:Commit)
		{
			_commit = c;
			drawBkgd();
			super.attachAvatar(_commit.email);
			super.setText(_commit.note, _commit.date);
			addEventListener(MouseEvent.CLICK, onItemSelection);
		}

		private function drawBkgd():void
		{
			_bkgd = new Box(500, 41, Box.WHITE, Box.DK_GREY);
			_bkgd.scalable = true;
			_bkgd.stroke = Box.LT_GREY;
			_bkgd.scaleOffset = 210;
			_ptrn = new Box(500, 41, Box.WHITE);
			_ptrn.scalable = true;
			_ptrn.scaleOffset = 210;
			_ptrn.pattern = new Diagonals();
			_ptrn.alpha = .1;
			addChild(_bkgd);
			addChild(_ptrn);
		}
		
		private function onItemSelection(e:MouseEvent):void
		{
			trace("HistoryItemSaved.onItemSelection(e)", _commit);
		}

	}
	
}
