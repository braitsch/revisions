package view.history {

	import com.greensock.TweenLite;
	import events.UIEvent;
	import model.vo.Commit;
	import view.Box;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _bkgd			:Box;
		private var _over			:Box;
		private var _ptrn			:Box;
		private var _commit			:Commit;

		public function HistoryItemSaved()
		{
			drawBkgd();
			addEventListener(MouseEvent.CLICK, onItemSelection);
			addEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
		}
		
		public function set commit(o:Commit):void
		{
			_commit = o;
			super.attachAvatar(_commit.email);
			super.setText(_commit.note, 'Saved '+_commit.date);
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
			_over = new Box(500, 41, Box.WHITE);
			_over.scalable = true;
			_over.stroke = Box.LT_GREY;
			_over.scaleOffset = 210;
			_over.alpha = 0;			
			addChild(_bkgd);
			addChild(_ptrn);
			addChild(_over);
		}
		
		private function onItemSelection(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT_OPTIONS, _commit));
		}
		
		private function onItemRollOver(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:1});	
		}

		private function onItemRollOut(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:0});
		}		

	}
	
}
