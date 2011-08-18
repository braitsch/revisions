package view.modals.remote {

	import model.proxies.remote.BeanstalkProxy;

	public class AddBkmkToBeanstalk extends AddBkmkToAccount {

		private static var _proxy	:BeanstalkProxy;
		private static var _view	:NewRemoteMC = new NewRemoteMC();

		public function AddBkmkToBeanstalk(p:BeanstalkProxy)
		{
			_proxy = p;
			super(_view);
			super.drawBackground(550, 210);
		}
		
	}
	
}
