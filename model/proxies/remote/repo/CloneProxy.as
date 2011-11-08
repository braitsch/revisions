package model.proxies.remote.repo {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;
	import view.windows.modals.system.Confirm;
	import com.adobe.crypto.MD5;
	import flash.filesystem.File;

	public class CloneProxy extends GitProxy {

		private static var _cloneURL		:String;
		private static var _repoName		:String;
		private static var _clonedFile		:File;
		private static var _savePath		:File;
		private static var _bookmark		:Bookmark;

		public function clone(url:String, dest:File):void
		{
			if (super.working) return;
			_cloneURL = url; _savePath = dest; _repoName = Repository.getRepositoryName(url);
			if (_savePath.resolvePath(_repoName).exists){
				confirmDownload();
			}	else{
				initCloneRequest();
			}
		}

		private function initCloneRequest():void
		{
			super.request = new GitRequest(BashMethods.CLONE, new Repository('origin', _cloneURL), [_savePath.nativePath]);
		}
		
		override protected function onProcessSuccess(e:NativeProcessEvent):void
		{
			switch(e.data.method) {
				case BashMethods.CLONE :
					onCloneComplete();
				break;
			}
			super.onProcessSuccess(e);
		}

		private function onCloneComplete():void
		{
			var a:Array = _savePath.resolvePath(_repoName).getDirectoryListing();
			if (a.length == 2){
			// user cloned a repo with a single file //	
				for (var i:int = 0; i < a.length; i++) if (a[i].name == '.git') a.splice(i, 1);
				_clonedFile = a[0];
				if (_savePath.resolvePath(_clonedFile.name).exists){
					confirmOverwrite();
				}	else{
					setupLocalFileRepo();
				}
			}	else{
				_clonedFile = null;
				addFolderBookmark();
			}
		}

		private function confirmDownload():void 
		{
			var f:File = _savePath.resolvePath(_repoName);
			var s:String = f.isDirectory ? 'folder' : 'file';
			var m:String = 'The '+s+' "'+f.name+'" has the same name as the package you\'re about to download and will be overwritten if you continue.\n';
				m += 'Would you like to continue?';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirmDownload);
			AppModel.alert(k);
		}
		
		private function confirmOverwrite():void 
		{
			var m:String = 'A file named "'+_clonedFile.name+'" already exists in the location you chose to download to and will be overwritten if you continue.\n';
				m += 'Would you like to continue?';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirmOverwrite);
			AppModel.alert(k);
		}

		private function onConfirmDownload(e:UIEvent):void
		{
			if (e.data == true){
				var f:File = _savePath.resolvePath(_repoName);
					f.isDirectory ? f.deleteDirectory(true) : f.deleteFile();
				initCloneRequest();
			}
		}	
		
		private function onConfirmOverwrite(e:UIEvent):void
		{
			if (e.data == true){
				setupLocalFileRepo();
			}	else{
			// trash the downloaded files //
				_savePath.resolvePath(_repoName).deleteDirectory(true);
			}			
		}		
	
		private function setupLocalFileRepo():void
		{
			var f:File = _savePath.resolvePath(_clonedFile.name);
			_clonedFile.moveTo(f, true);
			var d:File = File.applicationStorageDirectory.resolvePath(MD5.hash(f.nativePath));
			_savePath.resolvePath(_repoName).moveTo(d, true);
			AppProxies.creator.setWorkTree(d.nativePath, _savePath.nativePath);
			AppModel.engine.addEventListener(AppEvent.WORKTREE_SET, addFileBookmark);
		}
		
		private function addFileBookmark(e:AppEvent):void
		{
			var o:Object = {
				label		:	StringUtils.capitalize(_clonedFile.name),
				type		: 	Bookmark.FILE,
				path		:	_savePath.resolvePath(_clonedFile.name).nativePath,
				active 		:	1,
				autosave	:	60 
			};
			_bookmark = new Bookmark(o);
			addTrackingBranches();
		}
		
		private function addFolderBookmark():void
		{
			var o:Object = {
				label		:	StringUtils.capitalize(_repoName),
				type		: 	Bookmark.FOLDER,
				path		:	_savePath.resolvePath(_repoName).nativePath,
				active 		:	1,
				autosave	:	60 
			};
			_bookmark = new Bookmark(o);
			addTrackingBranches();
		}
		
		private function addTrackingBranches():void
		{
			AppProxies.editor.addTrackingBranches(_bookmark);
			AppModel.engine.addEventListener(AppEvent.TRACKING_BRANCHES_SET, onBranchesSet);
		
		}		
		private function onBranchesSet(e:AppEvent):void
		{
			AppModel.engine.addBookmark(_bookmark);
			AppModel.dispatch(AppEvent.CLONE_COMPLETE);
		}
		
//		private function stripPassFromRemoteURL():void
//		{
//			trace('_cloneURL: ' + (_cloneURL));
//			var b:Boolean = false;
//			var u:String = _cloneURL;
//			if (u.search(/(https:\/\/)(\w*)(:)/) != -1){
//				b = true; u = u.substr(8); // strip off https://
//				var a:String = u.substr(0, u.indexOf(':'));
//				u = 'https://' + a + u.substr(u.indexOf('@'));
//			}
//			trace("CloneProxy.stripPassFromRemoteURL()", u);
//			_repository = new Repository('origin', u);
//			b ? editRemoteURL() : onRemoteEdited();
//		}			
		

	}
	
}
