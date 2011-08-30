package view.modals.base {

	import events.AppEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class ModalWindowForm extends ModalWindow {
		
		private var _view			:*;
		private var _inputs			:*;

		public function ModalWindowForm(v:*)
		{
			_view = v;
			addChild(_view);
		}
		
		protected function set labels(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) _view.form['label'+(i+1)].text = a[i];
		}

		protected function get fields():Array
		{
			var a:Array = [];
			for (var i:int = 0; i < _inputs.length; i++) a.push(_inputs[i].text);
			return a;
		}		
		
		protected function validate():Boolean
		{
			for (var i:int = 0; i < _inputs.length; i++){
				if (_inputs[i].text == '') {
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
					return false;
				}
			}
			return true;
		}
		
		protected function set inputs(v:*):void
		{
			_inputs = v;
			for (var i:int = 0; i < v.length; i++) {
				if (v[i] is TextField){
					v[i].tabIndex = i;
					v[i].displayAsPassword = true;
					v[i].addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}	else if (v[i] is TLFTextField){
					InteractiveObject(v[i].getChildAt(1)).tabIndex = i;
					v[i].getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}
				v[i].addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			}
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			unlockScreen();
			super.onAddedToStage(e);
			_inputs[0].setSelection(0, _inputs[0].length);
			_inputs[0].textFlow.interactionManager.setFocus();			
		}

		private function onFocusIn(e:FocusEvent):void
		{
			if (e.target is TextField){
				e.target.setSelection(0, e.target.length);
			}	else if (e.target is Sprite){
				e.target.parent.setSelection(0, e.target.parent.length);
			}
		}
		
 		protected function unlockScreen():void { }
		
	}
	
}
