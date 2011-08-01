package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import model.vo.Remote;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class RemoteRepo extends ModalWindow {

		private var _bkmk	:Bookmark;
		private var _name	:String;
		private var _view	:NewRemoteMC = new NewRemoteMC();
		private var _check	:ModalCheckbox = new ModalCheckbox(_view.check, false);	
		private var _proxy	:*;	

		public function RemoteRepo()
		{
			addChild(_view);
			super.addCloseButton();
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_check.label = 'Make Repository Private';
			_view.pageBadge.label_txt.text = 'Add To Github';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		protected function get view():NewRemoteMC { return _view; }
		protected function set proxy(p:NativeProcessProxy):void { _proxy = p; }
		
		public function set bookmark(b:Bookmark):void
		{
			_bkmk = b;
			_view.name_txt.text = _bkmk.label;	
		}
		
		override public function onEnterKey():void { onOkButton();}		
		protected function onOkButton(e:MouseEvent = null):void 
		{ 
			if (validate()) addRepository();
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
		
		protected function checkForDuplicate():Boolean
		{
			_name = 'rvgh-'+_view.name_txt.text.replace(/\s/, '-').toLowerCase();
			if (_bkmk.getRemoteByProp('name', _name)){
				return true;
			}	else{
				return false;
			}
		}
		
		protected function addRepository():void
		{
			_proxy.addRepository(_view.name_txt.text, _view.desc_txt.text, _check.selected==false);
			_proxy.addEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Creating New Github Repository'));
		}
		
		private function onRepositoryCreated(e:AppEvent):void
		{
			var url:String = e.data as String;
			addNewRemote(new Remote(_name, url, url));
			_proxy.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}
		
		private function addNewRemote(rmt:Remote):void
		{
			AppModel.proxies.remote.addRemote(rmt);
			AppModel.proxies.remote.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOADER_TEXT, 'Sending Files To Github'));			
		}

		private function onRemoteSynced(e:AppEvent):void
		{
			trace("AddRemoteRepo.onRemoteSynced(e)");
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.proxies.remote.removeEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);	
		}
		
	}
	
}
