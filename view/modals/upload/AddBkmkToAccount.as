package view.modals.upload {

	import events.AppEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.HostingProvider;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindow;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AddBkmkToAccount extends ModalWindow {

		private static var _bkmk		:Bookmark;
		private static var _host		:HostingProvider;
		private static var _form		:Form = new Form(new Form2());
		private static var _view		:NewRemoteMC = new NewRemoteMC();
		private static var _check		:ModalCheckbox = new ModalCheckbox(_view.check, false);

		public function AddBkmkToAccount()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.defaultButton = _view.ok_btn;
			_form.y = 70; _view.addChildAt(_form, 0);
			_form.labels = ['Name', 'Description'];
			_form.inputs = Vector.<TLFTextField>([_view.name_txt, _view.desc_txt]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
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

		override protected function onAddedToStage(e:Event):void
		{
			_bkmk = AppModel.bookmark;
			_view.name_txt.text = _bkmk.label.toLowerCase().replace(' ', '-');
			super.onAddedToStage(e);
		}
		
		override public function onEnterKey():void { onOkButton();}		
		private function onOkButton(e:MouseEvent = null):void 
		{
			if (validate()){
				var o:Object = {	bkmk:_bkmk, acct:_host.api,
									name:_view.name_txt.text,
									desc:_view.desc_txt.text, 
									publik:_check.selected == false	};
				AppModel.proxies.remote.addBkmkToAccount(o);
			}
		}

		private function validate():Boolean
		{
			if (_form.validate() == false){
				return false;
			}	else if (checkForDuplicate() == true){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Remote repository already exists.'));
				return false;
			}	else{
				return true;
			}
		}
		
		private function checkForDuplicate():Boolean
		{
			var n:String = _view.name_txt.text.replace(/\s/, '-').toLowerCase();
			if (_bkmk.getRemoteByProp('name', _host.type.toLowerCase()+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}
		
	}
	
}
