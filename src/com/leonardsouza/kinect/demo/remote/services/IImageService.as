package com.leonardsouza.kinect.demo.remote.services
{
	public interface IImageService
	{
		function loadGallery(numberOfImages:uint, searchTerm:String = null):void;
	}
}