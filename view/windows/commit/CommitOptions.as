package view.windows.commit {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import view.type.TextHeading;
	import view.windows.base.ChildWindow;
	import flash.events.MouseEvent;

	public class CommitOptions extends ChildWindow {

		private static var _commit		:Commit;
		private static var _heading		:TextHeading = new TextHeading('What would you like to do?'); 
		private static var _branch		:DrawButton = new DrawButton(400, 40, 'Start a new branch from this version', 12);
		private static var _saveCopy	:DrawButton = new DrawButton(400, 40, 'Save a copy of this version to my computer', 12);

		public function CommitOptions()
		{
			_branch.icon = new ButtonIcon(new BranchIcon());
			_branch.icon.scaleX = _branch.icon.scaleY = 1.3; 
			_saveCopy.icon = new ButtonIcon(new SaveCopy());
			_saveCopy.icon.scaleX = _saveCopy.icon.scaleY = 1.2; 			
			_branch.y = 100; _saveCopy.y = 160;
			_branch.x = _saveCopy.x = 279 - _branch.width / 2;
			_branch.addEventListener(MouseEvent.CLICK, onNewBranch);
			_saveCopy.addEventListener(MouseEvent.CLICK, onSaveLocal);
			addChild(_branch); addChild(_saveCopy); addChild(_heading);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
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
			super.browseForDirectory('Choose a location to save this copy of "'+AppModel.bookmark.label+'"');
		}	
		
		private function onBrowserSelection(e:UIEvent):void
		{
			var bkmk:Bookmark = AppModel.bookmark;
			var saveAs:String = e.data.nativePath+'/'+bkmk.label+' Version '+_commit.index;
			if (bkmk.type == Bookmark.FILE) saveAs += bkmk.path.substr(bkmk.path.lastIndexOf('.'));
			AppModel.proxies.editor.copyVersion(_commit.sha1, saveAs);
		}				
		
	}
	
}
