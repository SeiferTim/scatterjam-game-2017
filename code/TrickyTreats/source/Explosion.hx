package;

import axollib.GraphicsCache;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Explosion extends FlxSprite 
{

	public function new() 
	{
		super();
		
		frames = GraphicsCache.loadGraphicFromAtlas("explosion", AssetPaths.explosion__png, AssetPaths.explosion__xml).atlasFrames;
		animation.addByStringIndices("explode", "explosion00", ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"], ".png", 15, false);
		
		
	}
	
	
	public function spawn(X:Float, Y:Float):Void
	{
		reset(X - (width / 2), Y - (height*.75));
		animation.play("explode");
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