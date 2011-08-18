package view.modals.remote {

	import events.AppEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.HostingProvider;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AddBkmkToAccount extends ModalWindow {

		private static var _bkmk		:Bookmark;
		private static var _host		:HostingProvider;
		private static var _view		:NewRemoteMC = new NewRemoteMC();
		private static var _newRepo		:Object;
		private static var _check		:ModalCheckbox = new ModalCheckbox(_view.check, false);

		public function AddBkmkToAccount()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.defaultButton = _view.ok_btn;			
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function set host(o:HostingProvider):void
		{
			_host = o;
			addOptions();
			setTitle(_view, o.addRepoObj.title);
		}

		private function addOptions():void
		{
			if (_host.addRepoObj.option){
				_check.visible = true;
				_check.label = _host.addRepoObj.option;
			}	else{
				_check.visible = false;
			}
		}

		private function onAddedToStage(e:Event):void
		{
			_bkmk = AppModel.bookmark;
			_view.name_txt.text = _bkmk.label.toLowerCase().replace(' ', '-');
		}
		
		override public function onEnterKey():void { onOkButton();}		
		private function onOkButton(e:MouseEvent = null):void 
		{
			if (validate()){
				_host.proxy.makeNewAccountRepo(_view.name_txt.text, _view.desc_txt.text, _check.selected==false); 
				_host.proxy.addEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);
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
		private function checkForDuplicate():Boolean
		{
			var n:String = _view.name_txt.text.replace(/\s/, '-').toLowerCase();
			if (_bkmk.getRemoteByProp('name', _host.type.toLowerCase()+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}
		
//			var m:String = 'This bookmark is already associated with a GitHub account.\n';
//				m+='Name : '+g.name+'\n';
//				m+='Url : '+g.fetch+'\n';
//			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));			
		
		private function onRepoCreated(e:AppEvent):void
		{
			_newRepo = e.data as Object;
			_host.proxy.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);
		// 	AppModel.proxies.editor add bookmark to the newly created repo
		//	AppModel.proxies.editor.syncRemotes(v);
		//	AppModel.proxies.editor.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);			
		}		
		
//		private function onRemoteSynced(e:AppEvent):void
//		{
//			trace("AddRemoteRepo.onRemoteSynced(e) -- yay!!");
//			trace('bookmark added to github successfully - goto account / show on github');
//			dispatchEvent(new UIEvent(UIEvent.SHOW_NEW_REPO_CONFIRM, _newRepo));
//			AppModel.proxies.editor.removeEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);	
//		}
		
	}
	
}
