package view.modals.remote {

	import model.remote.RemoteAccount;
	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.proxies.remote.RepositoryProxy;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class AddRemoteRepo extends ModalWindow {

		private var _bkmk		:Bookmark;
		private var _view		:NewRemoteMC = new NewRemoteMC();
		private var _check		:ModalCheckbox = new ModalCheckbox(_view.check, false);	
		private var _proxy		:RepositoryProxy;	
		private var _newRepo	:Object;

		public function AddRemoteRepo()
		{
			addChild(_view);
			super.addCloseButton();
			super.defaultButton = _view.ok_btn;			
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_check.label = 'Make Repository Private';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		protected function get view():NewRemoteMC { return _view; }
		protected function set proxy(p:RepositoryProxy):void { _proxy = p; }
		
		public function set bookmark(b:Bookmark):void
		{
			_bkmk = b;
			_view.name_txt.text = _bkmk.label.toLowerCase().replace(' ', '-');
		}
		
		override public function onEnterKey():void { onOkButton();}		
		protected function onOkButton(e:MouseEvent = null):void 
		{ 
			if (validate()) {
				_proxy.createRemoteRepository(_view.name_txt.text, _view.desc_txt.text, _check.selected==false);
				_proxy.addEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);
				_proxy.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			}
		}

		private function validate():Boolean
		{
			if (_view.name_txt.text == '' || _view.desc_txt.text == '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
				return false;
			}	else if (checkForDuplicate() == true){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Remote repository already exists.'));
				return false;
			}	else{
				return true;
			}
		}
		
		// github-revisions-source
		protected function checkForDuplicate():Boolean
		{
			var n:String = _view.name_txt.text.replace(/\s/, '-').toLowerCase();
			if (_bkmk.getRemoteByProp('name', RemoteAccount.GITHUB+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}
		
		private function onRepoCreated(e:AppEvent):void
		{
			_newRepo = e.data as Object;
		}		
		
		private function onRemoteSynced(e:AppEvent):void
		{
			trace("AddRemoteRepo.onRemoteSynced(e) -- yay!!");
			trace('bookmark added to github successfully - goto account / show on github');
			dispatchEvent(new UIEvent(UIEvent.SHOW_NEW_REPO_CONFIRM, _newRepo));
			_proxy.removeEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);	
			_proxy.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);	
		}
		
	}
	
}
