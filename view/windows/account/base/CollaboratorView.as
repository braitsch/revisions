package view.windows.account.base {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import view.type.TextHeading;

	public class CollaboratorView extends AccountPage {

		private var _bkgd			:CollaboratorViewMC = new CollaboratorViewMC();
		private var _line1			:TextHeading = new TextHeading();

		public function CollaboratorView()
		{
			addChild(_bkgd);
			registerButtons();
			addTextHeadings();
		}

		private function registerButtons():void
		{
			super.enableButton(_bkgd.back);
			super.enableButton(_bkgd.addCollab);
			_bkgd.back.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			_bkgd.addCollab.addEventListener(MouseEvent.CLICK, onAddCollaborator);
		}
		
		private function addTextHeadings():void
		{
			_line1.y = 0; _line1.text = 'These are your collaborators.';
			_bkgd.addChild(_line1);
		}			
		
		private function onAddCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
		}			
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
			
	}
	
}