package view.windows.commit {

	import events.UIEvent;
	import model.vo.Commit;
	import view.ui.DrawButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CommitOptions extends Sprite {

		private static var _commit		:Commit;
		private static var _branch		:DrawButton = new DrawButton(460, 40, 'Start a new branch from this version', 12);
		private static var _saveCopy	:DrawButton = new DrawButton(460, 40, 'Or save a copy of this version to your computer', 12);

		public function CommitOptions()
		{
			_branch.y = 100;
			_saveCopy.y = 160;
			_branch.x = _saveCopy.x = 279 - 230;
			_branch.addIcon(new BranchIcon());
			_saveCopy.addIcon(new SaveIcon());
			_branch.addEventListener(MouseEvent.CLICK, onNewBranch);
			_saveCopy.addEventListener(MouseEvent.CLICK, onSaveLocal);
			addChild(_branch); addChild(_saveCopy);
		}
		
		public function set commit(o:Commit):void
		{
			_commit = o;
		}

		private function onNewBranch(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
		}
		
		private function onSaveLocal(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SAVE_COPY_OF_VERSION, _commit));
		}		
		
	}
	
}
