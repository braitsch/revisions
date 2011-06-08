package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Commit;
	import utils.FileBrowser;
	import flash.events.MouseEvent;

	public class WindowDownload extends ModalWindow {

		private static var _commit	:Commit;
		private static var _view	:WindowDownloadMC = new WindowDownloadMC();
		private static var _browser	:FileBrowser = new FileBrowser();

		public function WindowDownload()
		{
			addChild(_view);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			_view.download_btn.addEventListener(MouseEvent.CLICK, onDownload);
			super.addButtons([_view.cancel_btn, _view.download_btn]);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileBrowserSelection);			
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

		public function set commit(cmt:Commit):void
		{
			_commit = cmt;
			_view.message_txt.text = 'Are you sure you want to download "'+AppModel.bookmark.label+'" revision "'+cmt.note+'"?';
		}
		
		private function onCancel(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}

		private function onDownload(e:MouseEvent):void
		{
			_browser.browse('Choose a location to save '+AppModel.bookmark.label);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}

	}
	
}
