package com.leonardsouza.kinect.demo.signals
{
	import com.leonardsouza.kinect.animators.skeleton.Skeleton3D;
	
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	public class UserSkeletonUpdate extends Signal
	{
		public function UserSkeletonUpdate()
		{
			super(Skeleton3D);
		}
	}
}