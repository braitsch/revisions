package view.modals.login {

	import events.AppEvent;
	import model.AppModel;
	import view.modals.ModalWindow;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class BaseNameAndPass extends ModalWindow {

		private var _view:*;

		public function BaseNameAndPass(v:*)
		{
			_view = v;
			_view.form.label1.text = 'Username';
			_view.form.label2.text = 'Password';
			addChild(_view);
			setupTextFields();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override public function get name():String { return _view.name_txt.text; }
		protected function get pass():String { return _view.pass_txt.text; }
		
		protected function validate():Boolean
		{
			if (_view.name_txt.text && _view.pass_txt.text){
				return true;
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
				return false;
			}
		}
		
 		protected function unlockScreen():void { }
		
		private function onAddedToStage(e:Event):void 
		{
			unlockScreen();
			resize(stage.stageWidth, stage.stageHeight);
			_view.name_txt.setSelection(0, _view.name_txt.length);
			_view.name_txt.textFlow.interactionManager.setFocus();
		}
		
		private function setupTextFields():void
		{
			_view.pass_txt.displayAsPassword = true;
			_view.name_txt.text = _view.pass_txt.text = '';
			_view.pass_txt.tabIndex = 2;
			_view.pass_txt.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_view.name_txt.getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			InteractiveObject(_view.name_txt.getChildAt(1)).tabIndex = 1;
		}		
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (!this.stage) return;
			if (e.keyCode == 13){
				onEnterKey();
			}	else if (e.keyCode == 9){
				if (stage.focus == _view.pass_txt) _view.name_txt.setSelection(0, _view.name_txt.length);
			}
		}			
		
	}
	
}
