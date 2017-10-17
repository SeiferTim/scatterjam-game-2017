package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class TitleState extends FlxState 
{

	public var UI:MainUI;
	
	public var ready:Bool = false;
	
	public function new() 
	{
		super();

	}
	
	override public function create():Void 
	{
		
		SoundSystem.playMusic(AssetPaths.Halloween_Fun_4__mp3, -1, AssetPaths.Halloween_Fun_4__mp3);
		
		UI = new MainUI();
		
		
		add(new FlxSprite(0, 0, AssetPaths.title_screen__png));
		
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		var t:FlxBitmapText = new FlxBitmapText(font_light);
		t.text = "Press X to Play!";
		t.color = FlxColor.ORANGE;
		t.alignment = "center";
		t.screenCenter(FlxAxes.X);
		t.y = FlxG.height - t.height - 48;
		add(t);
		
		add(UI);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, function() {
			
			ready = true;
		});
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		Input.update(elapsed);
		if (ready)
		{
			if (Input.A_Button[Input.JUST_RELEASED] || Input.B_Button[Input.JUST_RELEASED] || Input.C_Button[Input.JUST_RELEASED] || Input.Start[Input.JUST_RELEASED])
			{
				ready = false;
				SoundSystem.endMusic(.33);
				FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
					FlxG.switchState(new PlayState());
				});
			}
		}
		super.update(elapsed);
	}
	
}