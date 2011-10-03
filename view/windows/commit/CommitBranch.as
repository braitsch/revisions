package view.windows.commit {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Commit;
	import view.btns.FormButton;
	import view.type.TextHeading;
	import view.ui.Form;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CommitBranch extends Sprite {

		private static var _commit		:Commit;
		private static var _form		:Form = new Form(534);
		private static var _heading		:TextHeading = new TextHeading('What would you like to call your new branch?');
		private static var _backBtn		:FormButton = new FormButton('Go Back');
		private static var _makeBtn		:FormButton = new FormButton('Create Branch');		

		public function CommitBranch()
		{
			setupForm();
			addButtons();
			addChild(_heading);
		}
		
		public function set commit(o:Commit):void
		{
			_commit = o;
		}		
		
		private function setupForm():void
		{
			_form.y = 100;
			_form.labelWidth = 100;
			_form.fields = [{label:'Branch Name'}];
			_form.setField(0, 'my-experimental-branch');			
			addChild(_form);
			addEventListener(UIEvent.ENTER_KEY, onEnterKey);
		}

		private function addButtons():void
		{
			_makeBtn.x = 419; _backBtn.x = 288; 
			_makeBtn.y = _backBtn.y = _form.y + 55;
			_makeBtn.addEventListener(MouseEvent.CLICK, onMakeButton);
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);
			addChild(_makeBtn); addChild(_backBtn);
		}

		private function onEnterKey(e:UIEvent):void
		{
			makeNewBranch();
		}		
		
		private function onMakeButton(e:MouseEvent):void
		{
			makeNewBranch();
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
		
		private function makeNewBranch():void
		{
			var n:String = _form.getField(0).replace(/\s/g, '-');
			for (var i:int = 0; i < AppModel.bookmark.branches.length; i++) {
				if (n == AppModel.bookmark.branches[i].name){
					AppModel.alert('Sorry, a branch with that name already exists. Please choose something else.');return;	
				}
			}
			AppModel.proxies.editor.addBranch(n, _commit);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));	
		}
		
	}
	
}
