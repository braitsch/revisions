package view.ui {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import view.modals.system.Message;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;

	public class Form extends Sprite {
		
		public static const	LEADING	:uint = 28;
		private var _view			:Sprite;
		private var _inputs			:*;
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
		}

		public function get fields():Array
		{
			var a:Array = [];
			for (var i:int = 0; i < _inputs.length; i++) a.push(_inputs[i].text);
			return a;
		}
		
		public function deactivateFields(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) _view[a[i]].transform.colorTransform = _tint;
		}
		
		public function validate():Boolean
		{
			for (var i:int = 0; i < _inputs.length; i++){
				if (_inputs[i].text == '') {
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('Neither field can be blank.')));
					return false;
				}
			}
			return true;
		}
		
		public function set inputs(v:*):void
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
				addChild(v[i]);
				v[i].x = 120;
				v[i].y = 15 + (LEADING * i);
				v[i].addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			}
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			if (this.stage && e.keyCode == 13) dispatchEvent(new UIEvent(UIEvent.ENTER_KEY));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			if (_inputs){
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
