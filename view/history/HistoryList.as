package view.history {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import view.bookmarks.Branch;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.ui.UIScrollBar;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryList extends Sprite {

	// each one of these represent one branch on a bookmark //
	
		private var _view			:HistoryListMC = new HistoryListMC();
		private var _modified		:Boolean = false;
		private var _branch			:Branch;
		private var _selected		:HistoryItem;
		private var _workingVersion	:HistoryItem;		
		
		private var _list			:SimpleList = new SimpleList();
		private var _scrollbar		:UIScrollBar = new UIScrollBar(8, 330, 8, 20);		

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			_view.tab.x = $xpos * 62;			_view.tab.label_txt.text = $branch.name;
			_view.addEventListener(MouseEvent.CLICK, onRecordSelection);
			
			addChild(_view);
			_view.addChild(_list);
			_list.y = 46;			
			generateScrollbar();
			AppModel.config.addEventListener(RepositoryEvent.SET_USERNAME, onUserNameChange);	
		}

		public function setRepositoryStatus(o:Object):void 
		{
			_modified = o[RepositoryStatus.M].length != 0;
			trace("HistoryList.onRepositoryStatus(e)", _modified);
			if (_selected) {
				switchToVersion();
			}	else{
				refreshList(AppModel.bookmark.master.history);
			}
		}

		private function refreshList(a:Array):void
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			if (_modified) v.push(_workingVersion);
			for (var i:int = 0; i < a.length; i++) v.push(new HistoryItem(String(a.length-i), a[i]));
			_list.refresh(v);		
		// check if we need the scrollbar //	
			_scrollbar.visible = _list.height > 314;
			trace("HistoryList.onBookmarkChange(e)", '# items = '+a.length);			
		}

		private function onRecordSelection(e:MouseEvent):void 
		{
			trace('------------------------------');
			_selected = e.target as HistoryItem;
			AppModel.status.getStatus();		
		}
		
		private function switchToVersion():void
		{
			if (_selected == _workingVersion) {
				AppModel.history.checkoutMaster();
			} else{
				AppModel.history.checkoutCommit(_selected.sha1);
			}		
			_selected = null;	
		}
		
		private function onUserNameChange(e:RepositoryEvent):void 
		{
			_workingVersion = new HistoryItem('X', '00##Right Now##'+AppModel.config.userName+'##Current Working Version');
		}		
		
		private function generateScrollbar():void 
		{
			_scrollbar.y = 24;
			_scrollbar.x = 655;
			_scrollbar.target = _list;
			_scrollbar.drawMask(650, 308);
			_scrollbar.visible = false;
			addChild(_scrollbar);	
		}			

	}
	
}
