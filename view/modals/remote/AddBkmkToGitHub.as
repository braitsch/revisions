package view.modals.remote {

	import model.proxies.remote.GitHubProxy;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class AddBkmkToGitHub extends AddBkmkToAccount {
		
		private static var _proxy	:GitHubProxy;
		private static var _view	:NewRemoteMC = new NewRemoteMC();
		private static var _check	:ModalCheckbox = new ModalCheckbox(_view.check, false);	

		public function AddBkmkToGitHub(p:GitHubProxy)
		{
			super(_view);
			super.drawBackground(550, 210);
			_proxy = p;
			_check.label = 'Make Repository Private';
			_view.pageBadge.label_txt.text = 'Add To Github';			
		}
		
		override protected function onOkButton(e:MouseEvent = null):void 
		{
			if (super.validate()){
				super.onOkButton();
				_proxy.createRemoteRepository(_view.name_txt.text, _view.desc_txt.text, _check.selected==false);
			}
		}
		
//			var m:String = 'This bookmark is already associated with a GitHub account.\n';
//				m+='Name : '+g.name+'\n';
//				m+='Url : '+g.fetch+'\n';
//			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));							
		
	}
	
}
