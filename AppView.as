package {
	import view.BaseView;
	import view.ColumnView;
	import view.layout.LayoutManager;
	import view.modals.ModalManager;

	import flash.display.Sprite;
	import flash.events.Event;

	public class AppView extends Sprite {
		
		private static var _base 		:BaseView = new BaseView();
		private static var _cols 		:ColumnView = new ColumnView();
		private static var _modal		:ModalManager = new ModalManager();

		public function AppView()
		{
			addChild(_base);			addChild(_cols);			addChild(_modal);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void 
		{
			LayoutManager.stage = this.stage;
			LayoutManager.base = _base.view;
			LayoutManager.columns = _cols.columns;
		}
					
	}
	
}
