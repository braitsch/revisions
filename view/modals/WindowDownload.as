package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Commit;
	import model.db.AppSettings;
	import utils.FileBrowser;
	import flash.events.MouseEvent;

	public class WindowDownload extends ModalWindow {

		private static var _commit	:Commit;
		private static var _view	:WindowDownloadMC = new WindowDownloadMC();
		private static var _browser	:FileBrowser = new FileBrowser();

		public function WindowDownload()
		{
			addChild(_view);
			super.addCheckboxes([_view.check1]);
			super.addButtons([_view.cancel_btn, _view.download_btn]);
			_view.check1.addEventListener(MouseEvent.CLICK, onCheckbox);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			_view.download_btn.addEventListener(MouseEvent.CLICK, onDownload);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileBrowserSelection);
			AppModel.settings.addEventListener(InstallEvent.SETTINGS, onUserSettings);			
		}
		
		public function set commit(cmt:Commit):void
		{
			_commit = cmt;
			_view.message_txt.text = 'Are you sure you want to download "'+AppModel.bookmark.label+'" revision "'+cmt.note+'"?';
		}
		
	// called from ModalManager if user chose not to be prompted before downloads //	
		public function selectDownloadLocation(e:MouseEvent = null):void
		{
			_browser.browse('Choose a location to save '+AppModel.bookmark.label);
		}
		
		private function onUserSettings(e:InstallEvent):void
		{
			_view.check1.cross.visible = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD) == 'false';
		}		

		private function onFileBrowserSelection(e:UIEvent):void
		{
			var file:String = '';
			var bkmk:Bookmark = AppModel.bookmark;
			var saveAs:String = e.data.nativePath+'/'+bkmk.label+' Version '+_commit.index;
			if (bkmk.file.isDirectory == false){
				file = bkmk.file.nativePath;
				saveAs += bkmk.file.nativePath.substr(bkmk.file.nativePath.lastIndexOf('.'));
			}			
			AppModel.proxies.checkout.download(_commit.sha1, saveAs, file);
		}
		
	// button event handlers //	

		private function onCheckbox(e:MouseEvent):void
		{
			_view.check1.cross.visible = !_view.check1.cross.visible;
			AppSettings.setSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD, _view.check1.cross.visible==false);				
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

	}
	
}
