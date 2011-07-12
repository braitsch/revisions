package view.fonts {

	import flash.text.Font;
	import flash.text.TextFormat;
	public class Fonts {
	
		private static var _arialBold		:Font = new ArialBold() as Font;			
		private static var _arialItalic		:Font = new ArialItalic() as Font;			
		private static var _helveticaBold	:Font = new HelveticaBold() as Font;
		private static var _kerning			:Number = .7;	
		
		public static var 	arialBold		:TextFormat = new TextFormat(_arialBold.fontName);
							arialBold.bold = true;
							arialBold.letterSpacing = _kerning;
							
		public static var 	arialItalic		:TextFormat = new TextFormat(_arialItalic.fontName);
							arialItalic.italic = true;							
							arialItalic.letterSpacing = _kerning;
							
		public static var 	helveticaBold		:TextFormat = new TextFormat(_helveticaBold.fontName);
							helveticaBold.color = 0x666666;
							helveticaBold.letterSpacing = .7;
							helveticaBold.bold = true;				
	}
	
}
