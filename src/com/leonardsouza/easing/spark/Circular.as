package com.leonardsouza.easing.spark
{
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	
	public class Circular extends EaseInOutBase
	{
		
		override protected function easeIn(ratio:Number):Number 
		{
			return -(Math.sqrt(1-ratio*ratio)-1);
		}
		
		override protected function easeOut(ratio:Number):Number 
		{
			return Math.sqrt(1-(ratio-1)*(ratio-1));
		}
		
		override protected function easeInOut(ratio:Number):Number 
		{
			return ((ratio *= 2) < 1) ? -0.5*(Math.sqrt(1-ratio*ratio)-1) : 0.5*(Math.sqrt(1-(ratio-=2)*ratio)+1);
		}
		
	}
}