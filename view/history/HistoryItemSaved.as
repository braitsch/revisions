package view.history {

	import events.UIEvent;
	import model.vo.Commit;
	import view.graphics.Box;
	import view.graphics.GradientBox;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _bkgd			:GradientBox = new GradientBox(true);
		private var _over			:SolidBox = new SolidBox(Box.WHITE, true);
		private var _ptrn			:PatternBox = new PatternBox(new Diagonals());
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
			_bkgd.draw(500, 41);
			_bkgd.scalable = true;
			_bkgd.scaleOffset = 210;
			_ptrn.draw(500, 41);
			_ptrn.scalable = true;
			_ptrn.scaleOffset = 210;
			_ptrn.alpha = .1;
			_over.draw(500, 41);
			_over.scalable = true;
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
