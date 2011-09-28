package view.windows.editor {

	import events.AppEvent;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import model.AppModel;
	import model.vo.Branch;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.btns.IconButton;

	public class BranchItem extends Sprite {

		private var _view		:BranchItemMC = new BranchItemMC();
		private var _name		:String;
		private var _branch		:Branch;

		public function BranchItem(b:Branch)
		{
			_branch = b;
			_view.name_txt.type = TextFieldType.INPUT;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.mouseEnabled = _view.desc_txt.mouseChildren = false;
			_view.name_txt.addEventListener(FocusEvent.FOCUS_IN, onNameFocusIn);
			_view.name_txt.addEventListener(FocusEvent.FOCUS_OUT, onNameFocusOut);
			_view.checkout.addEventListener(MouseEvent.CLICK, onBranchCheckout);
			new IconButton(_view.checkout);
			setTextFields(); attachAvatar(); addChild(_view);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, setTextFields);			
		}

		public function get branch():Branch { return _branch; }
		
		private function setTextFields(e:AppEvent = null):void
		{
			_view.checkout.visible = _branch != AppModel.branch;
			_view.name_txt.text = _branch.name;
			_view.desc_txt.text = 'Last Saved '+_branch.lastCommit.date+' :: '+_branch.lastCommit.note;
			if (_view.desc_txt.width > 420){
				_view.desc_txt.text = _view.desc_txt.text.substr(0, _view.desc_txt.getCharIndexAtPoint(420, _view.desc_txt.y))+'...';
			}
		}
		
		private function attachAvatar():void
		{
			var a:Avatar = Avatars.getAvatar(_branch.lastCommit.email);
				a.y = a.x = 6; 
			_view.addChild(a);
		}

		private function onNameFocusIn(e:FocusEvent):void
		{
			_name = _view.name_txt.text;
		}

		private function onNameFocusOut(e:FocusEvent):void
		{
			if (_view.name_txt.text == ''){
				_view.name_txt.text = _name;
				AppModel.alert('Name cannot be blank.');
			}	else if (_branch.name != _view.name_txt.text){
				var o:String = _branch.name; 
				var n:String = _view.name_txt.text;
				_branch.name = _view.name_txt.text;
				AppModel.proxies.editor.renameBranch(o, n);
			}
		}

		private function onBranchCheckout(e:MouseEvent):void
		{
			if (AppModel.branch.isModified){
				AppModel.alert('Please save your changes before moving to a new branch.');					
			}	else{
				AppModel.proxies.editor.changeBranch(_branch);
			}
		}

	}
	
}
