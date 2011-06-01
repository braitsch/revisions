package view.modals {

	import flash.display.Bitmap;

	public class WelcomeScreen extends ModalWindow {

		public function WelcomeScreen()
		{
			addChild(new Bitmap(new WelcomeMC()));
		}
	}
}
