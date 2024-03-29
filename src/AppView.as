package {

	import system.AirDragAndDrop;
	import view.bookmarks.BookmarkView;
	import view.frame.Header;
	import view.frame.MainView;
	import view.graphics.SolidBox;
	import view.windows.modals.ModalManager;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AppView extends Sprite {
		
		private static var _footer		:SolidBox = new SolidBox(0xc9c9c9);
		private static var _main		:MainView = new MainView();
		private static var _bkmks		:BookmarkView = new BookmarkView();
		private static var _header		:Header = new Header();
		private static var _modal		:ModalManager = new ModalManager();
		private static var _base		:Sprite = new Sprite();
		private static var _dragAndDrop	:AirDragAndDrop = new AirDragAndDrop();	

		public function AppView()
		{
			addChildren();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function addChildren():void
		{
			_main.x = 204;
			_bkmks.y = _main.y = 61;
			_base.addChild(_main);
			_base.addChild(_bkmks);
			_base.addChild(_header);
			_base.addChild(_modal);
			_base.addChild(_footer);
			addChild(_base);
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
			var h:uint = stage.stageHeight - 20;
			_modal.resize(w, h);
			_bkmks.resize(h);
			_header.resize(w);
			_main.resize(w - _main.x, h - _main.y);
			_footer.y = h;
			_footer.draw(w, 20);
		}
		
	}
	
}
