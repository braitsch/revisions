package view.modals.bkmk {

	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Avatar;
	import model.vo.Branch;
	import view.ui.BasicButton;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;

	public class BranchItem extends Sprite {

		private var _view		:BranchItemMC = new BranchItemMC();
		private var _name		:String;
		private var _branch		:Branch;

		public function BranchItem(b:Branch)
		{
			_branch = b;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = _branch.name;
			_view.desc_txt.text = _branch.lastCommit.note;
			_view.desc_txt.mouseEnabled = _view.desc_txt.mouseChildren = false;
			_view.name_txt.addEventListener(FocusEvent.FOCUS_IN, onNameFocusIn);
			_view.name_txt.addEventListener(FocusEvent.FOCUS_OUT, onNameFocusOut);
			_view.checkout.addEventListener(MouseEvent.CLICK, onBranchCheckout);
			_view.checkout.visible = (AppModel.branch != _branch);
			new BasicButton(_view.checkout);
			attachAvatar();
			addChild(_view);
		}
		
		private function attachAvatar():void
		{
			var a:Avatar = new Avatar(_branch.lastCommit.email);
				a.y = a.x = 5; 
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
			}	else{
				trace("BranchItem.onNameFocusOut(e)", _view.name_txt.text);
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
