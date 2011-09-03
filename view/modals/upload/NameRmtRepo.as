package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;
	import view.ui.Form;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NameRmtRepo extends ModalWindowBasic {

		private static var _form		:Form;
		private static var _name		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _desc		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _url			:TLFTextField = new FINorm().getChildAt(0) as TLFTextField; 
		private static var _service		:String;
		private static var _heading		:TextHeading = new TextHeading();
		private static var _preview		:Form = new Form(new Form1());
		private static var _nextBtn		:NextButton = new NextButton();
		private static var _backBtn		:BackButton = new BackButton();

		public function NameRmtRepo()
		{
			addChild(_heading);
			_heading.x = 10; _heading.y = 70;
			addChild(_preview);
			_preview.addChild(_url);
			_preview.labels = ['URL Preview'];
			_preview.deactivateFields(['field1']);
			_url.x = 120; _url.y = 16; 
			_name.addEventListener(Event.CHANGE, onNameChange);
			
			super.addButtons([_backBtn]);
			super.defaultButton = _nextBtn;
			_backBtn.x = 380; _nextBtn.x = 484;
			_backBtn.y = _nextBtn.y = 280 - 35;
			addChild(_backBtn); addChild(_nextBtn);
			_nextBtn.addEventListener(MouseEvent.CLICK, onNextButton);
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);
		}

		public function set service(s:String):void
		{
			_service = s; attachForm();
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (_service == HostingAccount.GITHUB){
				_form = new Form(new Form2());
				_form.inputs = [_name, _desc];
				_form.labels = ['Name', 'Description'];
			}	else if (_service == HostingAccount.BEANSTALK){
				_form = new Form(new Form1());
				_form.inputs = [_name];
				_form.labels = ['Name'];
			}
			_form.y = 90; addChild(_form);
			_preview.y = 90 + _form.height + 10;
			_heading.label_txt.text = 'What would you like to call your bookmark inside your '+_service+' account?';			
			_form.addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			_name.text = AppModel.bookmark.label.toLowerCase();
			_desc.text = '(optional)';
			generatePreviewURL();
			super.onAddedToStage(e);
		}
		
		private function onNameChange(e:Event):void
		{
			generatePreviewURL();
		}		
		
		private function generatePreviewURL():void
		{
			if (_service == HostingAccount.GITHUB){
				_url.text = 'https://github.com/'+Hosts.github.loggedIn.acct+'/';
			} 	else if (_service == HostingAccount.BEANSTALK){
				_url.text = 'https://'+Hosts.beanstalk.loggedIn.acct+'.beanstalkapp.com/';
			}
			_url.text += _form.fields[0].replace(/\s/g, '-');
		}
		
		override public function onEnterKey():void { onNextButton(); }
		private function onNextButton(e:Event = null):void
		{
			if (validate()){
				dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, {repo:_name.text, desc:_desc.text, url:_url.text}));
			}
		}		
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
		
		private function validate():Boolean
		{	
			if (_name.text.search(/^\d/g) == -1){
				return true;			
			}	else{
				var m:String = 'The name of your bookmark online must begin with a letter.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}
		}
		
	}
	
}
