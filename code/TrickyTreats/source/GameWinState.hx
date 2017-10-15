package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class GameWinState extends FlxState 
{

	public var ready:Bool = false;
	
	public function new() 
	{
		super();
		
		
		
	}
	
	override public function create():Void 
	{
		add(new FlxSprite(0, 0, AssetPaths.win_screen__png));
		
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		var t:FlxBitmapText = new FlxBitmapText(font_light);
		t.text = "Press Any Key to Play Again!";
		t.color = FlxColor.PURPLE;
		t.alignment = "center";
		t.screenCenter(FlxAxes.X);
		t.y = FlxG.height - t.height - 48;
		add(t);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, function() {
			FlxG.sound.play(AssetPaths.Game_win__wav);
			ready = true;
		});
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (ready)
		{
			Input.update(elapsed);
			if (Input.A_Button[Input.JUST_RELEASED] || Input.B_Button[Input.JUST_RELEASED] || Input.C_Button[Input.JUST_RELEASED])
			{
				ready = false;
				FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
					FlxG.switchState(new PlayState());
				});
			}
		}
		super.update(elapsed);
	}
	
}