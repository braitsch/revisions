package view.history {

	import events.UIEvent;
	import model.proxies.AppProxies;
	import model.vo.Commit;
	import view.btns.ButtonIcon;
	import view.graphics.Box;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends HistoryItem {

		private var _over			:SolidBox;
		private var _star			:ButtonIcon;
		private var _bkgd			:PatternBox;
		private var _commit			:Commit;

		public function HistoryItemSaved(merged:Boolean)
		{
			merged ? drawMergedItem() : drawNormalItem();
			addEventListener(MouseEvent.CLICK, onItemSelection);
			addEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
		}

		private function drawNormalItem():void
		{
			_over = new SolidBox(Box.WHITE);
			_bkgd = new PatternBox(new HistoryItemBkgd()); 
			_star = new ButtonIcon(new CommitStar(), true, true);
			addChild(_bkgd); addChild(_over); _over.alpha = 0;
			addStar();
		}

		private function drawMergedItem():void
		{
			_bkgd = new PatternBox(new HistoryItemMerged());
			_star = new ButtonIcon(new CommitStar(), true, false);
			addChild(_bkgd); addStar();
		}
		
		public function set commit(o:Commit):void
		{
			_commit = o;
			_star.tint = _commit.starred ? 0xEDC950 : 0x999999;
			super.attachAvatar(_commit.email);
			super.setText(_commit.note, 'Version '+_commit.index+' - Saved '+_commit.date);
		}
		
		override public function setWidth(w:uint):void
		{
			_star.x = w - 38;
			_bkgd.draw(w, 42);
			super.setWidth(w);
			if (_over) _over.draw(w, 41);
		}
		
		private function addStar():void
		{
			_star.y = 21;
			_star.addEventListener(MouseEvent.ROLL_OUT, onStarRollOut);
			_star.addEventListener(MouseEvent.ROLL_OVER, onStarRollOver);
			addChild(_star);
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
				AppProxies.editor.starCommit(_commit);
			}	else{
				AppProxies.editor.unstarCommit(_commit);			
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
