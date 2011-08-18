package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.Account;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AddBkmkToAccount extends ModalWindow {

		private var _bkmk		:Bookmark;
		private var _newRepo	:Object;
		private var _view		:NewRemoteMC;

		public function AddBkmkToAccount(v:NewRemoteMC)
		{
			_view = v;
			addChild(_view);
			super.addCloseButton();
			super.defaultButton = _view.ok_btn;			
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]));
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Description';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			_bkmk = AppModel.bookmark;
			_view.name_txt.text = _bkmk.label.toLowerCase().replace(' ', '-');
		}
		
		override public function onEnterKey():void { onOkButton();}		
		protected function onOkButton(e:MouseEvent = null):void 
		{ 
			AppModel.proxies.editor.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.proxies.editor.addEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);
		}

		protected function validate():Boolean
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
			if (_bkmk.getRemoteByProp('name', Account.GITHUB+'-'+n)){
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
			AppModel.proxies.editor.removeEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);	
			AppModel.proxies.editor.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepoCreated);	
		}
		
	}
	
}
