package;
import flixel.FlxG;
import flixel.math.FlxPoint;
import openfl.Lib;
import openfl.system.Capabilities;

typedef Resolution =
{
	var width:Int;
	var height:Int;
}

class Reg 
{

	public static var resolutions:Array<Resolution> = 
	[
		{width: 800,	height: 450},
		{width: 960,	height: 540},
		{width: 1024,	height: 546},
		{width: 1280,	height: 720},
		{width: 1600,	height: 900},
		{width: 1920,	height: 1080},
		{width: 2560,	height: 1440}
		
	];
	
	
	public static function resize(W:Float, H:Float) 
	{
		#if desktop
		FlxG.resizeWindow(Std.int(W), Std.int(H));
		#if openfl_legacy
		FlxG.stage.x = (Capabilities.screenResolutionX / 2) - (FlxG.stage.width / 2);
		FlxG.stage.y = (Capabilities.screenResolutionY / 2) - (FlxG.stage.height / 2);
		#else
		Lib.application.window.move(
				Std.int(
						(Capabilities.screenResolutionX / 2) - (Lib.application.window.width / 2)
						), 
				Std.int(
						(Capabilities.screenResolutionY / 2) - (Lib.application.window.height / 2)
						)
				);
		#end
		#end
	}
	
}