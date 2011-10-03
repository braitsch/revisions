package {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import system.AirDragAndDrop;
	import view.bookmarks.BookmarkView;
	import view.frame.Header;
	import view.frame.MainView;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.windows.modals.ModalManager;

	public class AppView extends Sprite {
		
		private static var _drag		:DragCorner = new DragCorner();
		private static var _main		:MainView = new MainView();
		private static var _bkgd		:SolidBox = new SolidBox(Box.WHITE);
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
			_bkmks.y = _main.y = 66;
			_base.addChild(_main);
			_base.addChild(_bkmks);
			_base.addChild(_header);
			_base.addChild(_modal);
			addChild(_bkgd);
			addChild(_base);
		}

		private function onAddedToStage(e:Event):void 
		{
			_modal.init(stage);
			_dragAndDrop.target = stage;
			addStageControls();
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
			_drag.x = w - _drag.width; 
			_drag.y = h - _drag.height + 20;
			drawBackground(stage.stageWidth, stage.stageHeight);
		}

		private function drawBackground(w:uint, h:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginFill(0xc9c9c9);
			_bkgd.graphics.drawRect(0, 0, w, h);
			_bkgd.graphics.endFill();
		}
		
		private function addStageControls():void
		{
			_drag.buttonMode = true;
			_drag.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
			addChild(_drag);
		}

		private function startResize(e:MouseEvent):void
		{
			this.stage.nativeWindow.startResize();
		}				

	}
	
}
