package {

	import system.AirDragAndDrop;
	import view.Header;
	import view.MainView;
	import view.bookmarks.BookmarkView;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.windows.modals.ModalManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AppView extends Sprite {
		
		private static var _drag		:Sprite = new Sprite();
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
			_base.x = 4;
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
			var w:uint = stage.stageWidth - 8;
			var h:uint = stage.stageHeight - 14;
			_modal.resize(w, h);
			_header.resize(w + 4);
			_bkmks.resize(h-_bkmks.y);
			_main.resize(w - _main.x, h - _main.y);
			_drag.x = w-46; _drag.y = h-42;
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
			var b:SolidBox = new SolidBox(0xff0000);
				b.draw(50, 50);
			_drag.addChild(b);				
			_drag.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
			_header.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
			addChild(_drag);
		}

		private function startMove(e:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
			this.stage.nativeWindow.startMove();
		}	
		
		private function startResize(e:MouseEvent):void
		{
			this.stage.nativeWindow.startResize();
		}				

	}
	
}
