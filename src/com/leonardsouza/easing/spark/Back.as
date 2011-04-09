package com.leonardsouza.easing.spark
{
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	
	public class Back extends EaseInOutBase
	{
		
		private var _strength:Number = 1.70158;
		
		public function get strength():Number
		{
			return _strength;
		}

		public function set strength(value:Number):void
		{
			if (value <= 0) value = .01;
			_strength = value;
		}

		override protected function easeIn(ratio:Number):Number 
		{
			return ratio*ratio*((strength+1)*ratio-strength);
		}
		
		override protected function easeOut(ratio:Number):Number 
		{
			return (ratio -= 1)*ratio*((strength+1)*ratio+strength)+1
		}
		
		override protected function easeInOut(ratio:Number):Number 
		{
			return ((ratio *= 2) < 1) ? 0.5*(ratio*ratio*((strength*1.525+1)*ratio-strength*1.525)) : 0.5*((ratio -= 2)*ratio*((strength*1.525+1)*ratio+strength*1.525)+2);
		}
	}
}