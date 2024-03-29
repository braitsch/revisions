package view.windows.commit {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import view.type.TextHeading;
	import view.windows.base.ChildWindow;
	import view.windows.modals.system.Message;
	import flash.events.MouseEvent;

	public class CommitOptions extends ChildWindow {

		private static var _commit		:Commit;
		private static var _heading		:TextHeading = new TextHeading('What would you like to do?'); 
		private static var _branch		:DrawButton = new DrawButton(380, 50, 'Start a new branch from this version', 12);
		private static var _saveCopy	:DrawButton = new DrawButton(380, 50, 'Save a copy of this version to my computer', 12);

		public function CommitOptions()
		{
			addChild(_heading);
			_branch.icon = new ButtonIcon(new BranchIcon());
			_branch.icon.scaleX = _branch.icon.scaleY = 1.3;
			_branch.addEventListener(MouseEvent.CLICK, onNewBranch);
			addChild(_branch); 
			_saveCopy.icon = new ButtonIcon(new SaveCopy());
			_saveCopy.icon.scaleX = _saveCopy.icon.scaleY = 1.2;
			_saveCopy.addEventListener(MouseEvent.CLICK, onSaveLocal);
			addChild(_saveCopy); 
			_branch.y = 110; _saveCopy.y = 180;
			_branch.x = _saveCopy.x = 279 - _branch.width / 2;
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		public function set commit(o:Commit):void
		{
			_commit = o;
		}

		private function onNewBranch(e:MouseEvent):void
		{
			if (AppModel.branch.isModified == false){
				dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
			}	else{
				AppModel.alert(new Message('Please save your changes before creating a new branch.'));
			}
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
			AppModel.showLoader('Fetching '+bkmk.label+' v'+_commit.index);
			AppProxies.status.locked = true;
			AppProxies.editor.copyVersion(_commit.sha1, saveAs);
			AppModel.engine.addEventListener(AppEvent.COPY_COMPLETE, onCopyVersionComplete);
		}

		private function onCopyVersionComplete(e:AppEvent):void
		{
			AppModel.hideLoader();
			AppProxies.status.locked = false;
			AppModel.engine.removeEventListener(AppEvent.COPY_COMPLETE, onCopyVersionComplete);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
