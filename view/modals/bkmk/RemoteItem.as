package view.modals.bkmk {

	import flash.text.TextFieldAutoSize;
	import model.vo.Remote;
	import flash.display.Sprite;

	public class RemoteItem extends Sprite {

		private var _remote	:Remote;
		private var _view	:RemoteItemMC = new RemoteItemMC();

		public function RemoteItem(rmt:Remote)
		{
			addChild(_view);
			_remote = rmt;
			_view.url_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.url_txt.text = rmt.defaultURL;
			_view.name_txt.text = rmt.realName;
			if (_view.name_txt.width <= 190){
				_view.url_txt.x = 200;
			}	else{
				_view.url_txt.x = _view.name_txt.width + 10; 
			}
		}
		
	}
	
}
