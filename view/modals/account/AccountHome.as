package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindow;
	import view.modals.base.ModalWindowBasic;
	import view.modals.system.Message;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AccountHome extends ModalWindow {

		private var _mask			:Shape = new Shape();
		private var _view			:AccountHomeMC = new AccountHomeMC();
		private var _page			:ModalWindowBasic;
		private var _account		:HostingAccount;
		
	// sub-views //	
		private var _viewRepos		:RepositoryView = new RepositoryView();
		private var _viewCollabs	:CollaboratorView = new CollaboratorView();
		private var _addCollab		:AddCollaborator = new AddCollaborator();
		
		public function AccountHome()
		{
			addChild(_view);
			addChild(_mask);
			addLogOut();
			drawMask(600, 450);
			super.addCloseButton();
			super.drawBackground(600, 450);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function set account(a:HostingAccount):void
		{
			AccountView.account = _account = a;
			attachAvatar();
			_viewRepos.reset();
		}

		private function attachAvatar():void
		{
			_account.avatar.y = 8; 
			_account.avatar.x = 426;
			_view.addChild(_account.avatar);
			_view.badgePage.label_txt.text = _account.type == HostingAccount.GITHUB ? 'My Github' : 'My Beanstalk';
		}
		
	// alternating view modes //
		
		override protected function onAddedToStage(e:Event):void
		{
			attachPage(_viewRepos, 10);
			super.onAddedToStage(e);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			_view.removeChild(_page);	
		}				
		
		private function onWizardNext(e:UIEvent):void
		{
			switch(e.target){
				case _viewRepos :
					nextPage(_viewCollabs);
				break;
				case _viewCollabs :
					nextPage(_addCollab);
				break;
			}
		}
		
		private function onWizardPrev(e:UIEvent):void
		{
			switch(e.target){
				case _addCollab :
					prevPage(_viewCollabs);
				break;
				case _viewCollabs :
					prevPage(_viewRepos);
				break;
			}
		}		
		
		private function nextPage(p:ModalWindowBasic):void
		{
			TweenLite.to(_page, .5, {x:-600, onComplete:_view.removeChild, onCompleteParams:[_page]});
			attachPage(p, 600);
		}
		
		private function prevPage(p:ModalWindowBasic):void
		{
			TweenLite.to(_page, .5, {x:600, onComplete:_view.removeChild, onCompleteParams:[_page]});
			attachPage(p, -600);
		}
		
		private function attachPage(p:ModalWindowBasic, x:int):void
		{
			_page = p; _page.x = x; _page.y = 68; _view.addChild(_page); TweenLite.to(_page, .5, {x:10});			
		}
		
		private function drawMask(w:uint, h:uint):void
		{
			_mask.x = 0;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(4, 0, w-4, h-4);
			_mask.graphics.endFill();
			_view.mask = _mask;
		}
		
	// logout //	
		
		private function addLogOut():void
		{
			super.addButtons([_view.logOut]);
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);					
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			_account.type == HostingAccount.GITHUB ? Hosts.github.logOut() : Hosts.beanstalk.logOut();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('You Have Successfully Logged Out.')));
		}			
		
	}
	
}
