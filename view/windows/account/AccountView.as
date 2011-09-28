package view.windows.account {

	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.windows.base.ChildWindow;
	import flash.display.Sprite;

	public class AccountView extends ChildWindow {

		private static var _proxy			:ApiProxy;
		private static var _account			:HostingAccount;

		public static function set account(a:HostingAccount):void	
		{
			_account = a; 
			if (_account.type == HostingAccount.GITHUB){
				_proxy = Hosts.github.api;
			}	else if (_account.type == HostingAccount.BEANSTALK){
				_proxy = Hosts.beanstalk.api;
			}
		}
		
	// instance getters //	
		
		public function get account():HostingAccount
		{
			return _account;
		}

		public function get proxy():ApiProxy
		{
			return _proxy;
		}
		
		protected function enableButton(b:Sprite):void
		{
			b.buttonMode = true;
			b['over'].alpha = 0;
			b.addEventListener(MouseEvent.ROLL_OUT, onRollOut);	
			b.addEventListener(MouseEvent.ROLL_OVER, onRollOver);	
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:1});
		}

		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:0});
		}

	}
	
}
