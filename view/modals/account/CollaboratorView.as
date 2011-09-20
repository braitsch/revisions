package view.modals.account {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.ui.TextHeading;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CollaboratorView extends AccountView {

		private var _bkgd			:CollaboratorViewMC = new CollaboratorViewMC();
		private var _viewGH			:CollaboratorViewGH = new CollaboratorViewGH();
		private var _viewBS			:CollaboratorViewBS = new CollaboratorViewBS();
		private var _line1			:TextHeading = new TextHeading();

		public function CollaboratorView()
		{
			addChild(_bkgd);
			registerButtons();
			addTextHeadings();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		override protected function onAddedToStage(e:Event):void
		{
			if (numChildren > 1) removeChildAt(1);
			if (super.account.type == HostingAccount.GITHUB){
				addChild(_viewGH);
			}	else if (super.account.type == HostingAccount.BEANSTALK){
				addChild(_viewBS);
			}
		}		

		private function registerButtons():void
		{
			super.addButtons([_bkgd.back, _bkgd.addCollab]);
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
