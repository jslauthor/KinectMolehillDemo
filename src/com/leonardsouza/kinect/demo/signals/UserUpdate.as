package com.leonardsouza.kinect.demo.signals
{
	import com.leonardsouza.kinect.demo.remote.vo.UserStatusVO;
	
	import org.osflash.signals.Signal;
	
	public class UserUpdate extends Signal
	{
		public function UserUpdate()
		{
			super(UserStatusVO);
		}
	}
}