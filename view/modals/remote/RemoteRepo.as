package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.proxies.remote.RemoteProxy;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class RemoteRepo extends ModalWindow {

		private var _bkmk	:Bookmark;
		private var _name	:String;
		private var _view	:NewRemoteMC = new NewRemoteMC();
		private var _check	:ModalCheckbox = new ModalCheckbox(_view.check, false);	
		private var _proxy	:RemoteProxy;	

		public function RemoteRepo()
		{
			addChild(_view);
			super.addCloseButton(550);
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_check.label = 'Make Repository Private';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		protected function get view():NewRemoteMC { return _view; }
		protected function set proxy(p:RemoteProxy):void { _proxy = p; }
		
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
		//TODO this shit needs to be updated //	
			_name = 'rvgh-'+_view.name_txt.text.replace(/\s/, '-').toLowerCase();
			if (_bkmk.getRemoteByProp('name', _name)){
				return true;
			}	else{
				return false;
			}
		}
		
		protected function addRepository():void
		{
			_proxy.createRemoteRepository(_view.name_txt.text, _view.desc_txt.text, _check.selected==false);
			AppModel.proxies.ghRemote.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
		}
		
		private function onRemoteSynced(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.ghRemote.removeEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);	
		}
		
	}
	
}
