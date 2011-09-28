package view.type {

	import flash.filters.GlowFilter;

	public class WhiteHeading extends TextHeading {

		private static var _dkGlow	:GlowFilter = new GlowFilter(0x000000, .3, 2, 2, 3, 3);		

		public function WhiteHeading()
		{
			super.size = 12;
			super.color = 0xCCCCCC;
			super.letterSpacing = .8;
			super.label.wordWrap = false;
			super.label.multiline = false;
			this.filters = [_dkGlow];
		}
		
	}
	
}
