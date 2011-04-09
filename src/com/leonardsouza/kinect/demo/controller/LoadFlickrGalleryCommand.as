package com.leonardsouza.kinect.demo.controller
{
	import com.leonardsouza.kinect.demo.remote.services.IImageService;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoadFlickrGalleryCommand extends Command
	{
		
		[Inject]
		public var imageService:IImageService;
		
		override public function execute():void
		{
			imageService.loadGallery(75);
		}
	}
}