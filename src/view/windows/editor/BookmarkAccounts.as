package view.windows.editor {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Repository;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import view.type.TextHeading;
	import view.ui.ScrollingList;
	import view.windows.base.ChildWindow;
	import view.windows.modals.system.Confirm;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BookmarkAccounts extends ChildWindow {

		private static var _item		:AccountItem;
		private static var _repo		:Repository;
		private static var _heading		:TextHeading = new TextHeading();
		private static var _remotes		:ScrollingList = new ScrollingList();
		private static var _linkBtn		:DrawButton = new DrawButton(400, 40, 'Link This Bookmark To An Online Account', 11);		

		public function BookmarkAccounts()
		{
			addChild(_remotes);
			addChild(_heading);
			addUnlinkButton();
			_remotes.leading = 44;
			_remotes.bottomPadding = 8;
			_remotes.x = 10; _remotes.y = 95;
			_linkBtn.icon = new ButtonIcon(new LinkIcon());
			addEventListener(UIEvent.UNLINK_ACCOUNT, onUnlinkAccount);
			AppModel.engine.addEventListener(AppEvent.REMOTE_DELETED, onBkmkRemovedFromAcct);
		}
		
		private function addUnlinkButton():void
		{
			_linkBtn.x = 100; _linkBtn.y = 120;
			_linkBtn.addEventListener(MouseEvent.CLICK, onLinkToAccount);
			addChild(_linkBtn);
		}

		override protected function onAddedToStage(e:Event):void 
		{
			_remotes.clear();
			var v:Vector.<Repository> = AppModel.bookmark.remotes;
			if (v.length){
				attachRemotes(v);
			}	else{
				attachDefaultButton();
			}
		}

		private function attachDefaultButton():void
		{
			_linkBtn.visible = true;
			var m:String = 'It looks like you haven\'t saved this bookmark online yet.\n';
				m+= 'Why not link it up to your Beanstalk or GitHub account?';
			_heading.text = m;	
		}

		private function attachRemotes(v:Vector.<Repository>):void
		{
			for (var i:int = 0; i < v.length; i++) _remotes.addItem(new AccountItem(v[i]), i);
			_remotes.draw(580, 86, 2);
			_linkBtn.visible = false;
			_heading.text = 'Online Accounts Linked To This Bookmark';
		}

		private function onLinkToAccount(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_ACCOUNT));	
		}		
		
		private function onUnlinkAccount(e:UIEvent):void
		{
			_repo = e.data as Repository;
			_item = e.target as AccountItem;
			var m:String = 'You are about to unlink this bookmark from your '+_repo.acctType+' repository "'+_repo.repoName+'". ';
				m+='After unlinking you will not be able to sync with the copy of this bookmark that is on '+_repo.acctType+', ';
				m+='however those files will still be on their server so you can view them at anytime.\n';
				m+='Would you like to continue?';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.alert(k);
		}

		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) AppProxies.editor.delRemote(_repo);
		}

		private function onBkmkRemovedFromAcct(e:AppEvent):void
		{
			onAddedToStage(e);
		}
		
	}
	
}
