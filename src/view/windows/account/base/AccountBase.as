package view.windows.account.base {

	import com.greensock.TweenLite;
	import events.UIEvent;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.windows.base.ChildWindow;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;

	public class AccountBase extends ParentWindow {

		private var _mask			:Shape = new Shape();
		private var _view			:AccountHomeMC = new AccountHomeMC();
		private var _page			:ChildWindow;
		private var _account		:HostingAccount;
		
	// sub-views //	
		private var _viewRepos		:RepositoryView;
		private var _viewCollabs	:CollaboratorView;
		private var _addCollab		:AddCollaborator;
		
		private static const WIDTH 	:uint = 600;
		private static const HEIGHT	:uint = 450;
		
		public function AccountBase()
		{
			addChild(_view);
			addChild(_mask);
			addLogOut();
			drawMask(WIDTH, HEIGHT);
			super.addCloseButton();
			super.drawBackground(WIDTH, HEIGHT);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		override public function get height():Number
		{
			return HEIGHT;
		}
		
		protected function setViews(r:RepositoryView, c:CollaboratorView, a:AddCollaborator):void
		{
			_viewRepos = r;
			_viewCollabs = c;
			_addCollab = a;
		}
		
		protected function setHeading(s:String):void
		{
			_view.badgePage.label_txt.text = s;			
		}
		
		public function set account(a:HostingAccount):void
		{
			_account = a;
			attachAvatar();
		}

		private function attachAvatar():void
		{
			_account.avatar.y = 8;
			_account.avatar.x = 426;
			_view.addChild(_account.avatar);
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
		
		private function nextPage(p:ChildWindow):void
		{
			TweenLite.to(_page, .5, {x:-600, onComplete:_view.removeChild, onCompleteParams:[_page]});
			attachPage(p, 600);
		}
		
		private function prevPage(p:ChildWindow):void
		{
			TweenLite.to(_page, .5, {x:600, onComplete:_view.removeChild, onCompleteParams:[_page]});
			attachPage(p, -600);
		}
		
		private function attachPage(p:ChildWindow, x:int):void
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
			_view.logOut.buttonMode = true;
			_view.logOut['over'].alpha = 0;
			_view.logOut.addEventListener(MouseEvent.ROLL_OUT, onRollOut);	
			_view.logOut.addEventListener(MouseEvent.ROLL_OVER, onRollOver);	
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);	
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:1});
		}

		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:0});
		}		
		
		protected function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.alert(new Message('You Have Successfully Logged Out.'));
		}			
		
	}
	
}
