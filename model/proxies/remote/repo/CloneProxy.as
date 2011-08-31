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
			_cloneURL = url; _savePath = loc;
			super.request = new GitRequest(BashMethods.CLONE, _cloneURL, [_savePath]);
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
