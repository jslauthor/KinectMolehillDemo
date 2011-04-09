package com.leonardsouza.kinect.demo.model
{
	import com.leonardsouza.kinect.animators.skeleton.Skeleton3D;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SkeletonModel extends Actor
	{
		
		public static const MAX_SKELETONS:uint = 15;
		
		public var skeletons:Vector.<Skeleton3D>;
		
		public function SkeletonModel()
		{
			super();
			skeletons = new Vector.<Skeleton3D>();
			for (var x:int = 0; x <= MAX_SKELETONS; x++)
			{
				skeletons.push(new Skeleton3D());
			}
		}
	}
}