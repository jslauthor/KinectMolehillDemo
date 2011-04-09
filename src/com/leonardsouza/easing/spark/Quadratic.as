package com.leonardsouza.easing.spark
{
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	
	public class Quadratic extends EaseInOutBase
	{

		override protected function easeIn(ratio:Number):Number 
		{
			return ratio*ratio;
		}
		
		override protected function easeOut(ratio:Number):Number 
		{
			return -ratio*(ratio-2);
		}
		
		override protected function easeInOut(ratio:Number):Number 
		{
			return (ratio < 0.5) ? 2*ratio*ratio : -2*ratio*(ratio-2)-1;
		}
		
	}
}