package view.modals.account {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.vo.Repository;
	import view.modals.base.ModalWindow;
	import view.modals.base.ModalWindowBasic;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.events.Event;

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
			drawMask(590, 420);
			super.addCloseButton();
			super.drawBackground(590, 420);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function set account(a:HostingAccount):void
		{
			AccountView.account = _account = a;
			attachAvatar(); refreshUserInfo();
			_viewRepos.reset();
		}

		public function addRepository(o:Repository):void
		{
			_account.repositories.push(o);
			_viewRepos.reset();
		}
		
		private function attachAvatar():void
		{
			_account.avatar.y = 7; 
			_account.avatar.x = -190;
			_view.badgeUser.addChild(_account.avatar);
		}
		
		private function refreshUserInfo():void
		{
			_view.badgeUser.user_txt.text = _account.fullName ? _account.fullName : '';
			if (_account.fullName && _account.location) _view.badgeUser.user_txt.appendText(' - '+_account.location);			
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
					_viewCollabs.repository = e.data as Repository;
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
			_mask.graphics.drawRect(4, 0, w-8, h-4);
			_mask.graphics.endFill();
			_view.mask = _mask;
		}
		
	}
	
}
