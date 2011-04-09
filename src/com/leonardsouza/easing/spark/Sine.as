package com.leonardsouza.easing.spark
{
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	
	public class Sine extends EaseInOutBase
	{
		
		override protected function easeIn(ratio:Number):Number 
		{
			return 1-Math.cos(ratio * (Math.PI / 2));
		}
		
		override protected function easeOut(ratio:Number):Number 
		{
			return Math.sin(ratio * (Math.PI / 2));
		}
		
		override protected function easeInOut(ratio:Number):Number 
		{
			return -0.5*(Math.cos(ratio*Math.PI)-1);
		}
		
	}
}