package view.windows.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Repository;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import view.type.TextHeading;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class RepositoryView extends AccountView {
	
		private var _mask			:Shape = new Shape();
		private var _view			:RepositoryViewMC = new RepositoryViewMC();
		private var _line1			:TextHeading = new TextHeading();
		private var _line2			:TextHeading = new TextHeading();
		private var _repos			:Sprite = new Sprite();
		private var _upload			:DrawButton = new DrawButton(440, 50, 'Upload a bookmark to my account', 12);
		private var _cloneURL		:String;

		public function RepositoryView() 
		{
			addChild(_view);
			addUploadButton();
			addTextHeadings();
			buildRepoContainer();
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);
			addEventListener(UIEvent.GET_COLLABORATORS, onCollabClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		public function reset():void
		{
			while(_repos.numChildren) _repos.removeChildAt(0);
			if (super.account.repositories.length > 0){
				showRepositories();	
			}	else{
				showNoRepositories();		
			}
		}

		private function showRepositories():void
		{
			var v:Vector.<Repository> = super.account.repositories;
			for (var i:int = 0; i < v.length; i++) {
				var rp:RepositoryItem = new RepositoryItem(v[i]);
					rp.y = i * 41;
				_repos.addChild(rp);
			}
			_line1.text = 'Welcome, these are your '+super.account.acctType+' repositories!';
			_line2.text = 'Select one to download or to manage your collaborators';
			_upload.visible = false;
		}
		
		private function showNoRepositories():void
		{
			_line1.text = 'Welcome, you are now logged into your '+super.account.acctType+' account!';
			_line2.text = 'However it looks like you haven\'t uploaded any bookmarks yet.';
			_upload.visible = true;
		}
		
	// collaborators //
	
		private function onCollabClick(e:UIEvent):void
		{
			super.account.repository = e.data as Repository;
			if (super.account.repository.collaborators == null){
				requestCollaborators();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
			}
		}

		private function requestCollaborators():void
		{
			super.proxy.getCollaborators();
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorsReceived);
		}
	
		private function onCollaboratorsReceived(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorsReceived);
		}		
		
	// cloning // 	
		
		private function onCloneClick(e:UIEvent):void
		{
			_cloneURL = e.data as String;
			super.browseForDirectory('Where would you like to download these files?');
		}					
		
		private function onBrowserSelection(e:UIEvent):void
		{
			AppModel.proxies.clone.clone(_cloneURL, e.data as File);
			AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}
		
		private function buildRepoContainer():void
		{
			_view.addChild(_repos);
			_view.addChild(_mask);	
			_mask.y = _repos.y = 43;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(0, 0, 580, 328);
			_mask.graphics.endFill();
			_repos.mask = _mask;
		}
		
		private function addTextHeadings():void
		{
			addChild(_line1);
			addChild(_line2);
			_line1.y = 0; _line2.y = 17;
		}
		
		private function addUploadButton():void
		{
			addChild(_upload);
			_upload.y = 130;
			_upload.x = 290 - _upload.width / 2;
			_upload.icon = new ButtonIcon(new Upload());
			_upload.icon.scaleX = _upload.icon.scaleY = 1.2;
			_upload.addEventListener(MouseEvent.CLICK, onUploadClick);			
		}

		private function onUploadClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_ACCOUNT));
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			var h:uint = _repos.height - 11; // offset padding on pngs //
			if (h <= _mask.height) return;
			_repos.y += e.delta;
		// 43 is the home yPos of the repos container sprite //
			var minY:int = 43 - h + _mask.height;
			if (_repos.y >= 43) {
				_repos.y = 43;
			}	else if (_repos.y < minY){
				_repos.y = minY;
			}
		}			
		
	}
	
}
