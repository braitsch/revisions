package view.modals.login {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.vo.BookmarkRemote;
	import flash.events.MouseEvent;

	public class PermissionsFailure extends BaseNameAndPass {

		private static var _view		:PermissionsFailureMC = new PermissionsFailureMC();
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;

		public function PermissionsFailure()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 260);
			super.addButtons([_view.cancel_btn]);
			super.defaultButton = _view.ok_btn;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancelButton);
		}
		
		public function set request(u:String):void
		{
			var o:Object = BookmarkRemote.inspectURL(u);
			_acctType = o.acctType;
			_acctName = o.acctName;
			_repoName = o.repoName;
			var m:String = 'I\'m sorry, '+_acctType+' denied us access to the account named "'+_acctName+'".\n';
				m+='Please enter your username & password to try again :';
			super.setHeading(_view, m);
		// 	then dispatch RETRY_REMOTE_REQUEST with new url which will allow last used proxy to retry request.	
		}
		
		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(e:MouseEvent = null):void
		{
			if (super.validate()) {
				if (_acctType == HostingAccount.GITHUB){
				var s:String = 'https://' + super.name + ':' + super.pass + '@github.com/' + _acctName +'/'+ _repoName;
				trace('attempting request over https :: '+s);
				}	else if (_acctType == HostingAccount.BEANSTALK){
					// attempt to add revisions-rsa key to the target beanstalk account //
				var	u:String = 'http://'+super.name + ':' + super.pass+'accountname.beanstalkapp.com/api/public_keys.xml';
				trace('attempting to add ssh-key to :: '+u);
				// if ssh-key add is successful, retry the remote request //
				}
			// dispatch event or call proxy's callback //
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}
		
		private function onCancelButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
