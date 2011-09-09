package view.ui {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.modals.system.Message;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class Form extends Sprite {
		
		public static const	LEADING	:uint = 28;
		private var _view			:Sprite;
		private var _inputs			:Array;
		private static var _tint	:ColorTransform = new ColorTransform();
		private static var _grey	:uint = 0xCCCCCC;

		public function Form(v:Sprite)
		{
			_view = v;
			_tint.color = _grey;
			addChild(_view);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function set labels(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) _view['label'+(i+1)].text = a[i];
			addInputs(a);
		}
		
		public function getInput(n:uint):*
		{
			return _inputs[n];
		}
		
		public function getField(n:uint):String
		{
			return _inputs[n].text;
		}
		
		public function setField(n:uint, s:String):void
		{
			_inputs[n].text = s;	
		}
		
		public function set enabled(a:Array):void
		{
			for (var i:int = 0; i < _inputs.length; i++){
				if (i == a[i]-1){
					_inputs[i] is TextField ? _inputs[i].tabIndex = i : _inputs[i].getChildAt(1).tabIndex = i;
				}	else{
					_inputs[i].selectable = false;
					_inputs[i].type = TextFieldType.DYNAMIC;
					_view['field'+[i+1]].transform.colorTransform = _tint;
				}
			}
		}
		
		public function validate():Boolean
		{
			for (var i:int = 0; i < _inputs.length; i++){
				if (_inputs[i].text == '') {
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('Please fill in the required fields.')));
					return false;
				}
			}
			return true;
		}
		
		private function addInputs(v:Array):void
		{
			_inputs = [];
			for (var i:int = 0; i < v.length; i++) {
				var t:*;
				if (v[i] != 'Password') {
					t = new FINorm().getChildAt(0);
					t.getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);					
				}	else {
					t = new FIPass().getChildAt(0);
					t.displayAsPassword = true;
					t.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}
				addChild(t);
				t.x = 120;
				t.y = 15 + (LEADING * i);
				t.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				_inputs.push(t);
			}			
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (this.stage && e.keyCode == 13) dispatchEvent(new UIEvent(UIEvent.ENTER_KEY));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			if (_inputs[0].selectable){
				_inputs[0].setSelection(0, _inputs[0].length);
				_inputs[0].textFlow.interactionManager.setFocus();			
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
		
	}
	
}
