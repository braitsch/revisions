package model.remote {

	public class BeanstalkManager {
		
		
		private static var _accounts	:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function BeanstalkManager()
		{
			
		}
		
		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
		}
		
	}
	
}
