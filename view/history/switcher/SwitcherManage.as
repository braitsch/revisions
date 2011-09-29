package view.history.switcher {

	import view.graphics.SolidBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class SwitcherManage extends SwitcherItem {

		private static var _text		:TextHeading = new TextHeading('Manage My Branches');
		private static var _bkgd		:SolidBox = new SolidBox(0xc4c3c3, false);
		private static var _icon		:Bitmap = new Bitmap(new SwitcherItemDK());

		public function SwitcherManage()
		{
			super(_bkgd, _icon, _text);
			_text.color = 0x555555;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			trace("ManageBranches.onMouseClick(e)");
		}
		
	}
	
}
