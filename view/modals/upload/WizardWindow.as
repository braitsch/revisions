package view.modals.upload {

	import events.UIEvent;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WizardWindow extends ModalWindowBasic {

		private var _nextBtn			:Sprite;
		private var _backBtn			:BackButton;
		private var _heading			:TextHeading;
		
		protected function addHeading(s:String = ''):void
		{
			_heading = new TextHeading();
			_heading.label_txt.text = s;
			_heading.x = 10; _heading.y = 70;
			addChild(_heading);
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		protected function set heading(s:String):void
		{
			_heading.label_txt.text = s;
		}
		
		protected function addBackButton():void
		{
			_backBtn = new BackButton();
			_backBtn.x = 380;
			_backBtn.y = 280 - 35; // 280 window height //
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
			_nextBtn.x = 484;
			_nextBtn.y = 280 - 35;
			addChild(_nextBtn);			
			super.defaultButton = _nextBtn;
		}

		protected function onNextButton(e:Event):void
		{
			dispatchNext(e);	
		}
		
		protected function dispatchNext(e:Event = null, o:Object = null):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, o));
		}
		
		private function dispatchPrev(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}		
		
	}
	
}