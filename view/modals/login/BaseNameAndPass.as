package view.modals.login {

	import events.AppEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import view.modals.ModalWindow;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class BaseNameAndPass extends ModalWindow {
		
		private var _view:*;
		private var _fields :Array = [];

		public function BaseNameAndPass(v:*)
		{
			_view = v;
			addChild(_view);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function set labels(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) _view.form['label'+(i+1)].text = a[i];
		}
		
		protected function set fields(a:Array):void 
		{ 
			_fields = a;
			setupTextFields();
		}
		
		protected function get fields():Array
		{
			var a:Array = [];
			for (var i:int = 0; i < _fields.length; i++) a.push(_fields[i].text);
			return a;
		}
		
		protected function validate():Boolean
		{
			for (var i:int = 0; i < _fields.length; i++){
				if (_fields[i].text == '') {
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
					return false;
				}
			}
			return true;
		}
		
 		protected function unlockScreen():void { }
		
		private function onAddedToStage(e:Event):void 
		{
			unlockScreen();
			resize(stage.stageWidth, stage.stageHeight);
			_fields[0].setSelection(0, _fields[0].length);
			_fields[0].textFlow.interactionManager.setFocus();
		}
		
		private function setupTextFields():void
		{
			for (var i:int = 0; i < _fields.length; i++){
				_fields[i].text = '';
				if (_fields[i] is TextField){
					_fields[i].tabIndex = i;
					_fields[i].displayAsPassword = true;
					_fields[i].addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}	else if (_fields[i] is TLFTextField){
					InteractiveObject(_fields[i].getChildAt(1)).tabIndex = i;
					_fields[i].getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}
				_fields[i].addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			}
		}

		private function onFocusIn(e:FocusEvent):void
		{
			if (e.target is TextField){
				e.target.setSelection(0, e.target.length);
			}	else if (e.target is Sprite){
				e.target.parent.setSelection(0, e.target.parent.length);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (this.stage && e.keyCode == 13) onEnterKey();
		}			
		
	}
	
}
