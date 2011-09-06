package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;
	import view.ui.Form;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AddCollaborator extends ModalWindowBasic {

		private static var _form			:Form;
		private static var _heading			:TextHeading = new TextHeading();
		private static var _user			:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _okBtn			:OkButton = new OkButton();
		private static var _backBtn			:BackButton = new BackButton();	
		private static var _service			:String;
		private static var _serviceApi		:ApiProxy;
		private static var _repository		:String;
		private static var _collaborator	:String;

		public function AddCollaborator()
		{
			addChild(_heading);
			_heading.x = 10; _heading.y = 70;
			
			_form = new Form(new Form1());
			_form.labels = ['UserName'];
			_form.inputs = [_user];
			_form.y = 90;
			_form.addEventListener(UIEvent.ENTER_KEY, onNextButton);
			addChild(_form);
			
			super.defaultButton = _okBtn;
			super.addButtons([_backBtn]);
			_backBtn.x = 380; _okBtn.x = 484;
			_backBtn.y = _okBtn.y = 280 - 35;
			_okBtn.addEventListener(MouseEvent.CLICK, onNextButton);
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);			
			addChild(_okBtn); addChild(_backBtn);
		}
		
		public function set service(s:String):void
		{
			_service = s;
			_heading.label_txt.text = 'Please enter the '+_service+' user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
		}
		
		override public function onEnterKey():void { onNextButton(); }		
		private function onNextButton(e:Event = null):void
		{
			if (_form.validate()) {
				_collaborator = _form.fields[0]; _repository = 'revisions-bash';
				_serviceApi = _service == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api;
				_serviceApi.addCollaborator(_repository, _collaborator);
				_serviceApi.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);	
			}
		}
		
		private function onCollaboratorAdded(e:AppEvent = null):void
		{
			var m:String = 'Awesome! I just added "'+_collaborator+'" to your '+_service+' repository "'+_repository+'" ';
			m+='and just sent them an email so they\'re in the know. Rock on now & get back to work!';
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
			_serviceApi.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);	
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}			
		
	}
	
}
