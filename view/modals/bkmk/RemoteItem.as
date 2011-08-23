package view.modals.bkmk {

	import system.StringUtils;
	import flash.text.TextFieldAutoSize;
	import model.vo.BookmarkRemote;
	import flash.display.Sprite;

	public class RemoteItem extends Sprite {

		private var _remote	:BookmarkRemote;
		private var _view	:RemoteItemMC = new RemoteItemMC();

		public function RemoteItem(rmt:BookmarkRemote)
		{
			addChild(_view);
			_remote = rmt;
		// TODO - should show type, acctname & reponame	
			_view.url_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.url_txt.text = rmt.repoName.substr(0, -4);
			_view.name_txt.text = StringUtils.capitalize(rmt.type);
			if (_view.name_txt.width <= 190){
				_view.url_txt.x = 200;
			}	else{
				_view.url_txt.x = _view.name_txt.width + 10; 
			}
		}
		
	}
	
}
