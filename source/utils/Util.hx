package utils;

class Util
{
    /**
        Returns a random integer between 0 and the max integer.
        @param max The maximum integer that the function can return.
    **/
	public static function getRandomInt(max:Int)
	{
		return Math.floor(Math.random() * max);
	}

	// from https://github.com/KadeDev/Kade-Engine
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	public static function mapToRange(input:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float
	{
		var slope = (outMax - outMin) / (inMax - inMin);
		return outMin + Math.round(slope * (input - inMin));
	}
}