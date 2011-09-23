package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.proxies.remote.base.GitRequest;
	import model.vo.Bookmark;
	import system.BashMethods;
	import system.StringUtils;

	public class CloneProxy extends GitProxy {

		private static var _cloneURL	:String;
		private static var _savePath	:String;

		public function clone(url:String, loc:String):void
		{
			_cloneURL = url;
			_savePath = loc;
			super.request = new GitRequest(BashMethods.CLONE, _cloneURL, [_savePath]);
		}

		private function stripPassFromRemoteURL():void
		{
			if (super.request.url.search(/(https:\/\/)(\w*)(:)/) != -1){
				var u:String = super.request.url;
				u = u.substr(8); // strip off https://
				var a:String = u.substr(0, u.indexOf(':'));
				u = 'https://'+a+u.substr(u.indexOf('@'));
				rewriteRemoteURL(u);
			}	else{
				dispatchNewBookmark();
			}
		}

		private function rewriteRemoteURL(u:String):void
		{
			super.startTimer();
			super.appendArgs([_savePath]);
			super.call(Vector.<String>([BashMethods.EDIT_REMOTE, 'origin', u]));
		}
		
	// success / failure handlers //	

		override protected function onProcessSuccess(m:String):void
		{
			switch(m) {
				case BashMethods.CLONE :
					stripPassFromRemoteURL();
				break;
				case BashMethods.EDIT_REMOTE :
					dispatchNewBookmark();
				break;				
			}
		}

	// success request callbacks //	

		private function dispatchNewBookmark():void
		{
			trace("CloneProxy.dispatchNewBookmark()", _cloneURL);
			var n:String = _savePath.substr(_savePath.lastIndexOf('/') + 1);
			var o:Object = {
				label		:	StringUtils.capitalize(n),
				type		: 	Bookmark.FOLDER,
				path		:	_savePath,
				active 		:	1,
				autosave	:	60 
			};	
			AppModel.engine.addBookmark(new Bookmark(o));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
		}

	}
	
}
