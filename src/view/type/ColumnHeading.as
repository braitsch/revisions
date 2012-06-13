package view.type {

	import flash.filters.GlowFilter;

	public class ColumnHeading extends TextHeading {

		private static var _dkGlow	:GlowFilter = new GlowFilter(0x000000, .3, 2, 2, 3, 3);		

		public function ColumnHeading()
		{
			super.size = 12;
			super.color = 0xCCCCCC;
			super.letterSpacing = .8;
			super.multiline = false;
			this.filters = [_dkGlow];
		}
		
	}
	
}
