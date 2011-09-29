package view.history.switcher {

	import model.AppModel;
	import model.vo.Branch;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class SwitcherOption extends SwitcherItem {

		private var _branch		:Branch;
		private var _text		:TextHeading = new TextHeading();
		private var _bkgd		:GradientBox = new GradientBox(false);
		private var _icon		:Bitmap = new Bitmap(new SwitcherItemLT());
	
		public function SwitcherOption(b:Branch)
		{
			_branch	= b;
			_text = new TextHeading(_branch.name);
			_text.color = 0x555555;
			super(_bkgd, _icon, _text);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (AppModel.branch.isModified){
				AppModel.alert('Please save your changes before moving to a new branch.');					
			}	else{
				AppModel.proxies.editor.changeBranch(_branch);
			}
		}
		
	}
	
}
