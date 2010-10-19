package view {
	import commands.UICommand;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Toolbar extends Sprite {

		private static var _view:ToolbarMC = new ToolbarMC();

		public function Toolbar()
		{
			this.x = 96;
			this.y = 14;
			addChild(_view);
			addEventListener(MouseEvent.CLICK, onButtonSelection);
			for (var i:int = 0; i < _view.numChildren; i++) Sprite(_view.getChildAt(i)).buttonMode = true;
			disable([_view.branch_btn, _view.pull_btn, _view.push_btn, _view.ignore_btn]);
		}

		private function onButtonSelection(e:MouseEvent):void 
		{
			var n:Event;
			switch(e.target.name){
				case 'new_btn' 		: n = new UICommand(UICommand.ADD_BOOKMARK);	break;				case 'edit_btn' 	: n = new UICommand(UICommand.EDIT_BOOKMARK);	break;				case 'save_btn' 	: n = new UICommand(UICommand.SAVE_PROJECT);	break;				case 'delete_btn' 	: n = new UICommand(UICommand.DELETE_BOOKMARK);	break;				case 'history_btn' 	: n = new UICommand(UICommand.OPEN_HISTORY);	break;
			}
			if (n) dispatchEvent(n);
		}
		
		private function disable(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				a[i].alpha = .5;
				a[i].buttonMode = false;				a[i].mouseEnabled = false;				a[i].mouseChildren = false;
			}
		}
		
	}
	
}
