package view.modals.account {

	import events.UIEvent;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class RepositoryItem extends Sprite {

		private var _url	:String;
		private var _view	:RepositoryItemMC = new RepositoryItemMC();

		public function RepositoryItem(o:Object):void
		{
			_url = o.ssh_url || o.https_url; // https_url is beanstalk even though it is @git ! //
 			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = o.name;
			_view.desc_txt.text = o.description || 'No description available';
			addChild(_view);
			activateButton();
		}
		
		private function activateButton():void
		{
			_view.clone_btn.over.alpha = 0;
			_view.clone_btn.buttonMode = true;
			_view.clone_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			_view.clone_btn.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_view.clone_btn.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);			
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.LOGGED_IN_CLONE, _url));
		}
		
		private function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}			
		
	}
	
}