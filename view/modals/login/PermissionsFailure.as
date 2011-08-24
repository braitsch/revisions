package view.modals.login {

	import events.UIEvent;
	import model.vo.BookmarkRemote;
	import flash.events.MouseEvent;

	public class PermissionsFailure extends BaseNameAndPass {

		private static var _view		:RemotePasswordMC = new RemotePasswordMC();
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;

		public function PermissionsFailure()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 240);
			super.addButtons([_view.skip_btn]);
			super.defaultButton = _view.ok_btn;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
		}
		
		public function set request(u:String):void
		{
			var o:Object = BookmarkRemote.inspectURL(u);
			_acctType = o.acctType;
			_acctName = o.acctName;
			_repoName = o.repoName;
			super.setHeading(_view, 'Attempts to connect to your '+_acctType+' account '+_acctName+' have failed');
		// 	allow user to manually enter password and then build https url
		//	'https://' + u + ':' + p + '@github.com/' + u +'/'+ _repoName;
		// 	then dispatch RETRY_REMOTE_REQUEST with new url which will allow last used proxy to retry request.	
		}
		
		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(e:MouseEvent = null):void
		{
			if (super.validate()) {
			// dispatch event or call proxy's callback //
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}
		
		private function onSkipButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
