package view.windows.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.btns.FormButton;
	import view.type.TextHeading;
	import view.windows.base.ChildWindow;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WizardWindow extends ChildWindow {

		private var _nextBtn			:FormButton;
		private var _backBtn			:FormButton;
		private var _heading			:TextHeading;
		
		private static var _account			:HostingAccount;
		private static var _repoId			:uint;		// beanstalk only //
		private static var _repoName		:String;
		private static var _repoDesc		:String;	// github only  //
		private static var _repoURL			:String;
		private static var _repoPrivate		:Boolean;	// github only //
		private static var _buttonY			:uint = 300 - 50; // 300 window height //
		private static var _buttonX1		:uint = 280;
		private static var _buttonX2		:uint = 415;
		
		protected function addHeading(s:String = ''):void
		{
			_heading = new TextHeading();
			_heading.text = s;
			addChild(_heading);
		}
		
		protected function set heading(s:String):void
		{
			_heading.text = s;
		}
		
		protected function addBackButton():void
		{
			_backBtn = new FormButton('Back');
			_backBtn.y = _buttonY;
			_backBtn.x = _buttonX1;
			_backBtn.addEventListener(MouseEvent.CLICK, dispatchPrev);
			addChild(_backBtn);
		}
		
		protected function addNextButton(s:String = ''):void
		{
			_nextBtn = new FormButton(s || 'Next');
			_nextBtn.y = _buttonY;
			_nextBtn.x = _buttonX2;
			_nextBtn.addEventListener(MouseEvent.CLICK, onNextButton);
			addChild(_nextBtn);
		}		

		protected function moveBackButtonLeft():void
		{
			_backBtn.x = _buttonX1;
		}

		protected function moveBackButtonRight():void
		{
			_backBtn.x = _buttonX2;
		}		
		
		protected function onNextButton(e:Event):void
		{
			dispatchNext();
		}
		
		private function dispatchNext():void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
		}
		
		private function dispatchPrev(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}

		public function get account():HostingAccount { return _account; }
		public function set account(a:HostingAccount):void { _account = a; }

		public function get repoId():uint { return _repoId; }
		public function set repoId(repoId:uint):void { _repoId = repoId; }

		public function get repoName():String { return _repoName; }
		public function set repoName(repoName:String):void { _repoName = repoName; }

		public function get repoDesc():String { return _repoDesc; }
		public function set repoDesc(repoDesc:String):void { _repoDesc = repoDesc; }

		public function get repoURL():String { return _repoURL; }
		public function set repoURL(repoURL:String):void { _repoURL = repoURL; }

		public function get repoPrivate():Boolean { return _repoPrivate; }
		public function set repoPrivate(repoPrivate:Boolean):void { _repoPrivate = repoPrivate; }

	}
	
}
