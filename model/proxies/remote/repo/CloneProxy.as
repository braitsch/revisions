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
			super.call(Vector.<String>([BashMethods.CLONE, _cloneURL, _savePath]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Cloning Remote Repository'}));
		}

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
	//		dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD));
		}

		private function dispatchNewBookmark():void
		{
			var n:String = _savePath.substr(_savePath.lastIndexOf('/') + 1);
			var o:Object = {
				label		:	StringUtils.capitalize(n),
				type		: 	Bookmark.FOLDER,
				path		:	_savePath,
				active 		:	1,
				autosave	:	60 
			};	
			AppModel.engine.addBookmark(new Bookmark(o));
			dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
		}

	}
	
}
