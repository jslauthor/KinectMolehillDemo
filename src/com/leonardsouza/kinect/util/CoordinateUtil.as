package com.leonardsouza.kinect.util
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class CoordinateUtil
	{
		
		public static const X_RES:uint = 640;
		public static const Y_RES:uint = 480;
		
		public static function scalePixelCoordinate(width:uint, height:uint, point:Point):Point
		{
			var scaleX:Number = width / X_RES;
			var scaleY:Number = height / X_RES;
			
			return new Point(point.x * scaleX, point.y * scaleY);
		}
		
	}
}