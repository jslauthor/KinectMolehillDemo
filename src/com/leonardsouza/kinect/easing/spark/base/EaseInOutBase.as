package com.leonardsouza.easing.spark.base
{
	import spark.effects.easing.IEaser;
	
	public class EaseInOutBase implements IEaser
	{
		
		static public const EASE_IN:String = "easeIn";
		static public const EASE_OUT:String = "easeOut";
		static public const EASE_IN_OUT:String = "easeInOut";
		
		private var _easeType:String;
		
		public function EaseInOutBase(type:String = EASE_IN)
		{
			easeType = type;
		}
		
		public function get easeType():String
		{
			return _easeType;
		}

		public function set easeType(value:String):void
		{
			_easeType = value;
		}
		
		public function ease(fraction:Number):Number
		{
			switch(easeType)
			{
				case EASE_IN:
					return easeIn(fraction);
					break;
				case EASE_OUT:
					return easeOut(fraction);
					break
				case EASE_IN_OUT:
					return easeInOut(fraction);
					break;
				default:
					return fraction; // default is linear ease
			}
		}
		
		/* Override these with your own ease formulas */
		
		protected function easeIn(fraction:Number):Number { return 0; }
		protected function easeOut(fraction:Number):Number { return 0; }
		protected function easeInOut(fraction:Number):Number { return 0; }
		
	}
}