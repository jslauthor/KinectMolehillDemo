/*
* M2D 
* .....................
* 
* Author: Ely Greenfield
* Copyright (c) Adobe Systems 2011
* https://github.com/egreenfield/M2D
* 
* 
* Licence Agreement
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package com.leonardsouza.kinect.util
{
	
	public class Smoother
	{
		public var values:Vector.<Number>;
		public var length:int;
		public var average:Number = 0;
		public var sum:Number = 0;
		public var precision:Number = 2;
		public var resetDelta:Number;
		
		public function Smoother(len:int, reset:Number = 20)
		{
			values = new Vector.<Number>();
			length = len;
			resetDelta = reset;
		}
		public function sample(value:Number):void
		{
			if(isNaN(value) || value == Infinity)
				return;
			
			/* Slight modification here from LS */
			
			if (Math.abs(value - average) >= resetDelta)
			{
				values = new Vector.<Number>();
				sum = 0;
			}
			
			sum += value;
			values.push(value);
			if(values.length > length)
				sum -= values.shift();
			var precisionFactor:Number = Math.pow(10,precision);
			average = Math.floor(precisionFactor * sum/values.length)/precisionFactor;			
		}
	}
}