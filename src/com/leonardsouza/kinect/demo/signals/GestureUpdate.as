package com.leonardsouza.kinect.demo.signals
{
	import com.leonardsouza.kinect.demo.remote.vo.GestureVO;
	
	import org.osflash.signals.Signal;
	
	public class GestureUpdate extends Signal
	{
		public function GestureUpdate()
		{
			super(GestureVO);
		}
	}
}