package model.proxies.remote {

	import model.proxies.remote.AccountProxy;

	public class BeanstalkProxy extends AccountProxy {

		public function BeanstalkProxy()
		{
			super.executable = 'Beanstalk.sh';
		}
		
	}
	
}
