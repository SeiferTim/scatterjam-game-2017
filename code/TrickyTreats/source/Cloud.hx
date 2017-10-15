package;

import axollib.GraphicsCache;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Cloud extends FlxSprite
{

	public function new()
	{
		super();

		frames = GraphicsCache.loadGraphicFromAtlas("clouds", AssetPaths.clouds__png, AssetPaths.clouds__xml).atlasFrames;
		spawn(FlxG.random.float( -1000, FlxG.width + 5), FlxG.random.float( -80, 120));

	}

	public function spawn(X:Float, Y:Float):Void
	{
		x = X;
		y = Y;
		animation.randomFrame();

		velocity.x = FlxG.random.int(1, 5) * 2;
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (x > FlxG.width + 40)
		{
			spawn(FlxG.random.float( -2000, -1000), FlxG.random.float( -80, 120));
		}
	}

}