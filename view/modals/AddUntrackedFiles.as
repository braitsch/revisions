package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AddUntrackedFiles extends ModalWindow {

		private static var _view	:AutoInitMC = new AutoInitMC();

		public function AddUntrackedFiles()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn, _view.no_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkSelected);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			var s:String = '';
			s += 'This project '+AppModel.bookmark.label+' has '+AppModel.branch.untracked+' untracked files.<br>';
			s += 'Would you like me to start tracking all of them?<br>';
			s += 'You can always toggle tracking off on each file later.';
			_view.message_txt.htmlText = s;
		}
		
		private function onOkSelected(e:MouseEvent):void
		{
			AppModel.proxies.editor.commit('Bookmark Created', true);	
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
		
		private function onNoSelected(e:MouseEvent):void
		{
			AppModel.proxies.editor.commit('Bookmark Created', false);	
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}	
		
	}
	
}