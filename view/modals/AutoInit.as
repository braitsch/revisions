package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import view.ui.SimpleCheckBox;
	import flash.events.MouseEvent;

	public class AutoInit extends ModalWindow {

		private static var _view	:AutoInitMC = new AutoInitMC();
		private static var _check	:SimpleCheckBox;

		public function AutoInit()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn, _view.no_btn]);
			
			_check = new SimpleCheckBox(false, 'Do Not Ask Me Again');
			_check.x = 13;			_check.y = 161;
			addChild(_check);
			
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkSelected);			_view.no_btn.addEventListener(MouseEvent.CLICK, onNoSelected);
		}
		
		public function showMessage():void
		{
			var s:String = '';
			s +='The project '+AppModel.bookmark.label+' has '+AppModel.branch.untracked+' untracked files<br>';
			s +='Would you like me to automatically start tracking them for you?';
			_view.message_txt.htmlText = s;
		}
		
		private function onOkSelected(e:MouseEvent):void
		{
			onNoSelected(e);
			AppModel.proxies.editor.commit('Initial Import', true);			
		}
		
		private function onNoSelected(e:MouseEvent):void
		{
			AppModel.bookmark.disableAutoInit = _check.selected;
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}	
		
	}
	
}
