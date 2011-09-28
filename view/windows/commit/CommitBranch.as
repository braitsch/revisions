package view.windows.commit {

	import view.type.TextHeading;
	import events.UIEvent;
	import model.vo.Commit;
	import view.ui.DrawButton;
	import view.ui.Form;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CommitBranch extends Sprite {

		private static var _commit		:Commit;
		private static var _form		:Form = new Form(534);
		private static var _heading		:TextHeading = new TextHeading('What would you like to call your new branch?');
		private static var _okBtn		:DrawButton = new DrawButton(120, 30, 'Create Branch', 11);		

		public function CommitBranch()
		{
			_form.y = 100;
			_form.labelWidth = 100;
			_form.fields = [{label:'Branch Name'}];
			_form.setField(0, 'my-experimental-branch');
			_okBtn.x = 420; _okBtn.y = _form.y + 4;
			_okBtn.addEventListener(MouseEvent.CLICK, onOkButton);
			addChild(_form);
			addChild(_okBtn);
			addChild(_heading);
			addEventListener(UIEvent.ENTER_KEY, onEnterKey);
		}

		public function set commit(o:Commit):void
		{
			_commit = o;
		}		
		
		private function onEnterKey(e:UIEvent):void
		{
			trace("CommitOptions.onEnterKey(e) -- holla!");
		}	
		
		private function onOkButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}			
		
	}
	
}
