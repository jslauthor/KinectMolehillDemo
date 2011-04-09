package com.leonardsouza.easing.spark
{
	
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	
	public class Elastic extends EaseInOutBase
	{

		protected var a:Number=1;
		protected var p:Number=0.3;
		protected var s:Number=p/4;
		
		override protected function easeIn(ratio:Number):Number
		{
			if (ratio == 0 || ratio == 1) { return ratio; }
			return a * Math.pow(2, -10 * ratio) *  Math.sin((ratio - s) * (2 * Math.PI) / p) + 1;
		}
		
		override protected function easeOut(ratio:Number):Number {
			if (ratio == 0 || ratio == 1) { return ratio; }
			return a * Math.pow(2, -10 * ratio) *  Math.sin((ratio - s) * (2 * Math.PI) / p) + 1;
		}
		
		override protected function easeInOut(ratio:Number):Number {
			if (ratio == 0 || ratio == 1) { return ratio; }
			ratio = ratio*2-1;
			
			if (ratio < 0) {
				return -0.5 * (a * Math.pow(2, 10 * ratio) * Math.sin((ratio - s*1.5) * (2 * Math.PI) /(p*1.5)));
			}
			return 0.5 * a * Math.pow(2, -10 * ratio) * Math.sin((ratio - s*1.5) * (2 * Math.PI) / (p*1.5)) + 1;
		}
	}
}