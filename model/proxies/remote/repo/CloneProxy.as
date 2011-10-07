package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class CloneProxy extends GitProxy {

		private static var _cloneURL	:String;
		private static var _savePath	:String;
		private static var _bookmark	:Bookmark;
		private static var _repository	:Repository;

		public function clone(url:String, loc:String):void
		{
			_cloneURL = url; _savePath = loc;
			super.request = new GitRequest(BashMethods.CLONE, _cloneURL, [_savePath]);
		}

		override protected function onProcessSuccess(m:String):void
		{
			switch(m) {
				case BashMethods.CLONE :
					generateNewBookmark();
				break;	
			}
		}

		private function generateNewBookmark():void
		{
			var n:String = _savePath.substr(_savePath.lastIndexOf('/') + 1);
			var o:Object = {
				label		:	StringUtils.capitalize(n),
				type		: 	Bookmark.FOLDER,
				path		:	_savePath,
				active 		:	1,
				autosave	:	60 
			};
			_bookmark = new Bookmark(o);
			stripPassFromRemoteURL();
		}
		
		private function stripPassFromRemoteURL():void
		{
			var b:Boolean = false;
			var u:String = super.request.url;
			if (u.search(/(https:\/\/)(\w*)(:)/) != -1){
				b = true; u = u.substr(8); // strip off https://
				var a:String = u.substr(0, u.indexOf(':'));
				u = 'https://' + a + u.substr(u.indexOf('@'));
			}
			_repository = new Repository('origin', u);
			_bookmark.addRemote(_repository);
			b ? editRemoteRepoURL() : dispatchNewBookmark();
		}	
		
		private function editRemoteRepoURL():void
		{
			AppModel.proxies.editor.addEventListener(AppEvent.REMOTE_EDITED, onRemoteEdited);
			AppModel.proxies.editor.editRemote(_bookmark, _repository);
		}			
		
		private function onRemoteEdited(e:AppEvent):void 
		{
			dispatchNewBookmark();	
			AppModel.proxies.editor.removeEventListener(AppEvent.REMOTE_EDITED, onRemoteEdited);
		}

		private function dispatchNewBookmark():void
		{
			AppModel.engine.addBookmark(_bookmark);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
		}

	}
	
}
