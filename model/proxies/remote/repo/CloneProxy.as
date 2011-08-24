package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.vo.Bookmark;
	import system.BashMethods;
	import system.StringUtils;

	public class CloneProxy extends GitProxy {

		private static var _cloneURL	:String;
		private static var _savePath	:String;

		public function CloneProxy()
		{
			super.executable = 'RepoRemote.sh';
		}

		public function clone(url:String, loc:String):void
		{
			_cloneURL = url; _savePath = loc;
			trace("CloneProxy.clone(url, loc)", _cloneURL, _savePath);
			super.call(Vector.<String>([BashMethods.CLONE, _cloneURL, _savePath]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Cloning Remote Repository'}));
		}
		
	// success / failure handlers //	

		override protected function onProcessSuccess(m:String):void
		{
			switch(m) {
				case BashMethods.CLONE :
					dispatchNewBookmark();
				break;
			}
		}

		override protected function onAuthenticationFailure():void
		{
			super.inspectURL(_cloneURL);
			AppModel.engine.addEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);
		}

		private function onRetryRequest(e:AppEvent):void
		{
			if (e.data != null) this.clone(e.data as String, _savePath);
			AppModel.engine.removeEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);			
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
		}

	}
	
}
