package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class NewRemoteRepo extends ModalWindow {

		private static var _bkmk	:Bookmark;
		private static var _view	:NewRemoteMC = new NewRemoteMC();
		private static var _check	:ModalCheckbox = new ModalCheckbox(_view.check, false);		

		public function NewRemoteRepo()
		{
			addChild(_view);
			drawBackground(550, 210);
			super.addCloseButton();
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.pageBadge.label_txt.text = 'Add To GitHub';
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_check.label = 'Make Repository Private';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bkmk = b;
			_view.name_txt.text = _bkmk.label;	
		}
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(e:MouseEvent = null):void 
		{	
			if (_view.name_txt.text == '' || _view.desc_txt.text == '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Creating New Github Repository'));
				AppModel.proxies.githubApi.addRepository(_view.name_txt.text, _view.desc_txt.text, _check.selected==false);
				AppModel.proxies.githubApi.addEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
			}
		}

		private function onRepositoryCreated(e:AppEvent):void
		{
			var url:String = e.data as String;
			_bkmk.addRemote('revisions-github', url, url);
		// TODO also need to add this repository to the github home view...
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOADER_TEXT, 'Sending Files To Github'));
			AppModel.proxies.remote.linkToGitHub(e.data as String);
			AppModel.proxies.remote.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.proxies.githubApi.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}

		private function onRemoteSynced(e:AppEvent):void
		{
			trace("AddRemoteRepo.onRemoteSynced(e)");
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}
		
	}
	
}
