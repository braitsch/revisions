package {

	import flash.display.Sprite;
	import flash.events.Event;
	import system.AirDragAndDrop;
	import view.Header;
	import view.MainView;
	import view.bookmarks.BookmarkView;
	import view.modals.ModalManager;

	public class AppView extends Sprite {
		
		private static var _main		:MainView = new MainView();
		private static var _bkmks		:BookmarkView = new BookmarkView();
		private static var _header		:Header = new Header();
		private static var _modal		:ModalManager = new ModalManager();
		private static var _dragAndDrop	:AirDragAndDrop = new AirDragAndDrop();	

		public function AppView()
		{
			addChild(_main);
			addChild(_bkmks);
			addChild(_header);
			addChild(_modal);
			_main.x = 204;
			_bkmks.y = _main.y = 66;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void 
		{
			_modal.init(stage);
			_dragAndDrop.target = stage;
			stage.addEventListener(Event.RESIZE, onStageResize);
		}

		private function onStageResize(e:Event):void
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			_modal.resize(w, h);
			_header.resize(w);
			_bkmks.resize(h-_bkmks.y);
			_main.resize(w-_main.x, h-_main.y);
		}
					
	}
	
}
