package view.history {

	import model.AppModel;
	import events.UIEvent;
	import model.vo.Commit;
	import view.btns.ButtonIcon;
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
		private var _star			:ButtonIcon = new ButtonIcon(new CommitStar());
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
			_star.tint = _commit.starred ? 0xEDC950 : 0x999999;
			super.attachAvatar(_commit.email);
			super.setText(_commit.note, 'Saved '+_commit.date);
		}
		
		override public function setSize(w:uint, h:uint):void
		{
			_star.x = w - 38;
			_bkgd.draw(w, h);
			_ptrn.draw(w, h);
			_over.draw(w, h);
			super.setSize(w, h);
		}

		private function drawBkgd():void
		{
			_ptrn.alpha = .1;
			_over.alpha = 0;
			_star.y = 21;
			addChild(_bkgd);
			addChild(_ptrn);
			addChild(_over);
			addChild(_star);
			_star.addEventListener(MouseEvent.ROLL_OUT, onStarRollOut);
			_star.addEventListener(MouseEvent.ROLL_OVER, onStarRollOver);
		}

		private function onItemSelection(e:MouseEvent):void
		{
			if (e.target is CommitStar){
				favoriteCommit();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.COMMIT_OPTIONS, _commit));
			}
		}

		private function favoriteCommit():void
		{
			if (_commit.starred == false){
				AppModel.proxies.editor.starCommit(_commit);
			}	else{
				AppModel.proxies.editor.unstarCommit(_commit);			
			}
			_commit.starred = !_commit.starred;
		}

		private function onStarRollOver(e:MouseEvent):void
		{
			_star.tint = 0xEDC950;
		}

		private function onStarRollOut(e:MouseEvent):void
		{
			if (_commit.starred == false) _star.tint = 0x999999;
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
