package view.modals {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class DownloadVersion extends ModalWindow {

		private static var _commit	:Commit;
		private static var _view	:WindowDownloadMC = new WindowDownloadMC();
		private static var _check1	:ModalCheckbox = new ModalCheckbox(_view.check1, false);

		public function DownloadVersion()
		{
			addChild(_view);
			super.addCloseButton();
			super.addButtons([_view.cancel_btn, _view.download_btn]);
			_check1.label = "Next time just do it and don't ask me";
			_view.check1.addEventListener(MouseEvent.CLICK, onCheckbox);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			_view.download_btn.addEventListener(MouseEvent.CLICK, onDownload);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);			
			AppModel.settings.addEventListener(AppEvent.APP_SETTINGS, onUserSettings);			
		}
		
		public function set commit(cmt:Commit):void
		{
			_commit = cmt;
			_view.message_txt.text = 'Are you sure you want to download "'+AppModel.bookmark.label+'" revision "'+cmt.note+'"?';
		}
		
	// called from ModalManager if user chose not to be prompted before downloads //	
		public function selectDownloadLocation(e:MouseEvent = null):void
		{
			super.browseForDirectory('Choose a location to save '+AppModel.bookmark.label);
		}
		
		private function onUserSettings(e:AppEvent):void
		{
			_check1.selected = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD) == false;
		}		

	// button event handlers //	

		private function onCheckbox(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD, _check1.selected == false);				
		}		
		
		private function onCancel(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}

		private function onDownload(e:MouseEvent):void
		{
			selectDownloadLocation();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
		private function onBrowserSelection(e:UIEvent):void
		{
			var file:String = '';
			var bkmk:Bookmark = AppModel.bookmark;
			var saveAs:String = e.data.nativePath+'/'+bkmk.label+' Version '+_commit.index;
			if (bkmk.type == Bookmark.FILE){
				file = bkmk.path;
				saveAs += bkmk.path.substr(bkmk.path.lastIndexOf('.'));
			}			
			AppModel.proxies.checkout.download(_commit.sha1, saveAs, file);
		}		

	}
	
}
