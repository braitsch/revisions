package view.modals.system {


	public class Debug extends Alert {

		private var _view:DebugMC = new DebugMC();

		public function Debug(o:Object)
		{
			setMessage(o);
			addChild(_view);
			super.drawBackground(500, 400);
			super.setTitle(_view, '%&*@#^%!!');
			super.okButton = _view.ok_btn;
		}

		private function setMessage(o:Object):void
		{
			var m:String = 'Sorry, it looks like there was a problem! \n';
			m+='Source : '+o.source+'\n';
			m+='Method : '+o.method+' failed \n';
			m+='Message: '+o.message+'\n' || o.result+'\n';
			if (o.errors) for (var k:String in o.errors[0]) m+='Error: '+k+' -- '+o.errors[0][k]+'\n';		
			_view.message_txt.htmlText = m;
		}
		
	}
	
}
