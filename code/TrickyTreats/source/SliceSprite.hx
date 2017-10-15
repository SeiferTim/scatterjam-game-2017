package;

import flixel.addons.display.FlxSliceSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxSpriteUtil;

class SliceSprite extends FlxSliceSprite
{

	override private function blitTileOnCanvas(TileIndex:Int, Stretch:Bool, X:Float, Y:Float, Width:Float, Height:Float):Void
	{
		var tile:FlxGraphic = slices[TileIndex];
		
		if (tile != null)
		{
			FlxSpriteUtil.flashGfx.clear();
			
			_matrix.identity();
			
			if (Stretch)
				_matrix.scale(Width / tile.width, Height / tile.height);
			
			_matrix.translate(X, Y);
			FlxSpriteUtil.flashGfx.beginBitmapFill(tile.bitmap, _matrix);
			
			FlxSpriteUtil.flashGfx.drawRect(X, Y, Width, Height);
			renderSprite.pixels.draw(FlxSpriteUtil.flashGfxSprite, null, null);// colorTransform);
			FlxSpriteUtil.flashGfx.clear();
		}
	}
	
}