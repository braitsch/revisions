package view.modals.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import view.ui.TextHeading;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WizardWindow extends ModalWindowBasic {

		private var _nextBtn			:Sprite;
		private var _backBtn			:BackButton;
		private var _heading			:TextHeading;
		
		private static var _account			:HostingAccount;
		private static var _repoId			:uint;		// beanstalk only //
		private static var _repoName		:String;
		private static var _repoDesc		:String;	// github only  //
		private static var _repoURL			:String;
		private static var _repoPrivate		:Boolean;	// github only //
		
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
			_backBtn = new BackButton();
			_backBtn.x = 390;
			_backBtn.y = 300 - 35; // 300 window height //
			_backBtn.addEventListener(MouseEvent.CLICK, dispatchPrev);
			super.addButtons([_backBtn]);
			addChild(_backBtn);
		}
		
		protected function set backBtnX(x:uint):void
		{
			_backBtn.x = x;	
		}
		
		protected function set nextButton(s:Sprite):void
		{
			_nextBtn = s;
			_nextBtn.x = 491;
			_nextBtn.y = 300 - 35;
			addChild(_nextBtn);			
			super.defaultButton = _nextBtn;
		}

		protected function onNextButton(e:Event):void
		{
			dispatchNext();
		}
		
		protected function dispatchNext(e:Event = null):void
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
