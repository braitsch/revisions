package view.modals.login {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Remote;
	import system.StringUtils;
	import flash.events.MouseEvent;

	public class RemotePassword extends BaseNameAndPass {

		private static var _view	:RemotePasswordMC = new RemotePasswordMC();
		private static var _remote	:Remote;

		public function RemotePassword()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 240);
			super.addButtons([_view.skip_btn, _view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
		}

		public function set remote(r:Remote):void
		{
			_remote = r;
			_view.name_txt.text = _remote.acctName;
			var t:String = StringUtils.capitalize(r.type);
			var n:String = StringUtils.capitalize(r.acctName);
			super.setHeading(_view, 'Please enter the password for the '+t+' account "'+n+'"');
		}
		
		private function onOkButton(e:MouseEvent):void
		{
			var https:String = 'https://'+super.name+':'+super.pass+'@github.com/'+_remote.acctName+'/'+_remote.repoName;
			AppModel.proxies.ghRemote.attemptManualHttpsSync(https);
		}		
		
		private function onSkipButton(e:MouseEvent):void
		{
			AppModel.proxies.ghRemote.skipRemoteSync();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git		
		
	}
	
}
