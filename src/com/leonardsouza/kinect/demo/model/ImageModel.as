package com.leonardsouza.kinect.demo.model
{
	import com.leonardsouza.kinect.demo.signals.BitmapReady;
	
	import flash.display.BitmapData;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ImageModel extends Actor
	{
		
		[Inject]
		public var bitmapReady:BitmapReady;
		
		private var _bitmapData:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		public function get bitmaps():Vector.<BitmapData>
		{
			return _bitmapData;
		}

		public function set bitmaps(value:Vector.<BitmapData>):void
		{
			_bitmapData = value;
		}

		public function resetBitmaps():void
		{
			for each (var bd:BitmapData in _bitmapData)
			{
				bd.dispose();
			}
			
			_bitmapData = new Vector.<BitmapData>();
		}
	
		public function addBitmap(bitmapData:BitmapData):void
		{
			_bitmapData.push(bitmapData);
			bitmapReady.dispatch(_bitmapData.length-1);
		}
		
	}
}