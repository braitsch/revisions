package view.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import flash.events.EventDispatcher;

	public class RemoteClone extends EventDispatcher {

		private static var _cloneLoc:String;
		private static var _cloneURL:String;

		public static function getFromGitHub($url:String, $loc:String):void
		{
			_cloneURL = $url; _cloneLoc = $loc;
			AppModel.proxies.githubApi.clone(_cloneURL, _cloneLoc);
			AppModel.proxies.githubApi.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Connecting to Remote Repository'));				
		}
		
		private static function onCloneComplete(e:AppEvent):void
		{
			var n:String = _cloneLoc.substr(_cloneLoc.lastIndexOf('/') + 1);
				n = n.substr(0,1).toUpperCase() + n.substr(1);
			var o:Object = {
				label		:	n,
				type		: 	Bookmark.FOLDER,
				path		:	_cloneLoc,
				remote 		:	_cloneURL,
				active 		:	1,
				autosave	:	60
			};		
			AppModel.engine.addBookmark(new Bookmark(o));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.proxies.githubApi.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}			
		
	}
	
}
