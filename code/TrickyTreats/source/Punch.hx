package;

import axollib.GraphicsCache;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Punch extends FlxSprite 
{

	public function new() 
	{
		super();
		frames = GraphicsCache.loadGraphicFromAtlas("punch", AssetPaths.punch__png, AssetPaths.punch__xml).atlasFrames;
		animation.addByStringIndices("punch", "punch0", ["0", "1", "2", "3", "4", "5", "6"], ".png", 15, false);
		
	}
	
	public function spawn(X:Float, Y:Float):Void
	{
		reset(X - (width / 2), Y - (height));
		animation.play("punch");
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (animation.finished)
		{
			kill();
		}
		super.update(elapsed);
	}
	
}