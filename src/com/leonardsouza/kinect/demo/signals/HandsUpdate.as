package com.leonardsouza.kinect.demo.signals
{
	import com.leonardsouza.kinect.demo.model.vo.HandsVO;
	
	import org.osflash.signals.Signal;
	
	public class HandsUpdate extends Signal
	{
		public function HandsUpdate()
		{
			super(HandsVO);
		}
	}
}