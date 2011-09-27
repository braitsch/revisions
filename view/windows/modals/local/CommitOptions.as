package view.windows.modals.local {

	import events.UIEvent;
	import model.vo.Commit;
	import view.Box;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.type.TextDouble;
	import view.ui.DrawButton;
	import view.windows.base.ParentWindow;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CommitOptions extends ParentWindow {

		private static var _commit		:Commit;
		private static var _text		:TextDouble = new TextDouble();
		private static var _branch		:DrawButton = new DrawButton(310, 55, 'Start a new branch from this version', 12);
		private static var _saveLocal	:DrawButton = new DrawButton(310, 55, 'Save a copy of this version to my computer', 12);
		private static var _summary		:Sprite = new Sprite();

		public function CommitOptions()
		{
			attachSummary();
			attachButtons();
			super.addCloseButton();	
			super.title = 'Version Options';
			super.drawBackground(554, 300);
		}

		public function set commit(o:Commit):void
		{
			_commit = o;
			attachAvatar();
			_text.line1 = _commit.note;
			_text.line2 = 'Saved '+_commit.date;
			_text.maxWidth = 300;
		}		

		private function attachSummary():void
		{
			_text.x = 47; _text.y = 9;
			var w:Shape = new Shape();
				w.graphics.beginBitmapFill(new PageBadgeWhite());
				w.graphics.drawRect(0, 0, 378, 50);
				w.graphics.endFill();
			_summary.addChild(w);
			_summary.addChild(_text);
			_summary.x = 166;
			addChild(_summary);
		}
		
		private function attachAvatar():void
		{
			if (_summary.numChildren == 3) _summary.removeChildAt(2);
			var a:Avatar = Avatars.getAvatar(_commit.email);
				a.drawBackground(Box.LT_GREY, 2);
				a.x = a.y = 8;
			_summary.addChild(a);			
		}
		
		private function attachButtons():void
		{
			_branch.y = 90; _saveLocal.y = 170;
			_branch.x = _saveLocal.x = 277 - 155;
			_branch.addEventListener(MouseEvent.CLICK, onNewBranch);
			_saveLocal.addEventListener(MouseEvent.CLICK, onSaveLocal);
			addChild(_branch);
			addChild(_saveLocal);
		}

		private function onNewBranch(e:MouseEvent):void
		{
			trace("CommitOptions.onNewBranch(e)");
		}

		private function onSaveLocal(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SAVE_COPY_OF_VERSION, _commit));
		}
		
	}
	
}
