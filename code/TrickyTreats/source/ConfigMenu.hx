package;

import axollib.GraphicsCache;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class ConfigMenu extends FlxSubState 
{

	private var back:SliceSprite;
	private var title:FlxBitmapText;
	private var txtMuteMusic:FlxBitmapText;
	private var txtMuteSounds:FlxBitmapText;
	private var btnCheckMusic:FlxSprite;
	private var btnCheckSound:FlxSprite;
	private var txtFull:FlxBitmapText;
	private var btnCheckFull:FlxSprite;
	private var txtVolInfo:FlxBitmapText;
	
	private var ready:Bool = false;
	private var blackOut:FlxSprite;
	private var alpha(default, set):Float;
	
	
	public function new(CallBack:Void->Void) 
	{
		super(FlxColor.TRANSPARENT);
		
		
		closeCallback = CallBack;
		
		blackOut = new FlxSprite();
		blackOut.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackOut.scrollFactor.set();
		add(blackOut);
		
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		title = new FlxBitmapText(font_light);
		title.scrollFactor.set();
		title.text = "Settings";
		title.color = FlxColor.PURPLE;
		title.screenCenter(FlxAxes.X);
		title.y = (FlxG.height / 4) - title.height - 32;
		
		txtFull = new FlxBitmapText(font_light);
		txtFull.scrollFactor.set();
		txtFull.text = "Fullscreen";
		txtFull.color = FlxColor.PURPLE;
		
		txtFull.y = title.y + title.height + 24;
		
		btnCheckFull = new FlxSprite();
		btnCheckFull.frames = GraphicsCache.loadGraphicFromAtlas("checkbox", AssetPaths.checks__png, AssetPaths.checks__xml).atlasFrames;
		btnCheckFull.animation.addByNames("check-off-off", ["check-off-off.png"]);
		btnCheckFull.animation.addByNames("check-off-on", ["check-off-on.png"]);
		btnCheckFull.animation.addByNames("check-on-on", ["check-on-on.png"]);
		btnCheckFull.animation.addByNames("check-on-off", ["check-on-off.png"]);
		if (FlxG.fullscreen)
			btnCheckFull.animation.play("check-on-off");
		else
			btnCheckFull.animation.play("check-off-off");
		btnCheckFull.scrollFactor.set();
		
		btnCheckFull.y = txtFull.y + (txtFull.height / 2) - (btnCheckFull.height / 2);
		
		txtMuteSounds = new FlxBitmapText(font_light);
		txtMuteSounds.scrollFactor.set();
		txtMuteSounds.text = "Sound Effects";
		txtMuteSounds.color = FlxColor.PURPLE;
		txtMuteSounds.y = txtFull.y + txtFull.height + 24;
		
		btnCheckSound = new FlxSprite();
		btnCheckSound.frames = GraphicsCache.loadGraphicFromAtlas("checkbox", AssetPaths.checks__png, AssetPaths.checks__xml).atlasFrames;
		btnCheckSound.animation.addByNames("check-off-off", ["check-off-off.png"]);
		btnCheckSound.animation.addByNames("check-off-on", ["check-off-on.png"]);
		btnCheckSound.animation.addByNames("check-on-on", ["check-on-on.png"]);
		btnCheckSound.animation.addByNames("check-on-off", ["check-on-off.png"]);
		if (FlxG.sound.muted)
		{
			btnCheckSound.animation.play("check-off-off");
		}
		else
		{
			btnCheckSound.animation.play("check-on-off");
		}
		
		btnCheckSound.scrollFactor.set();
		
		btnCheckSound.y = txtMuteSounds.y + (txtMuteSounds.height / 2) - (btnCheckSound.height / 2);
		
		txtMuteMusic = new FlxBitmapText(font_light);
		txtMuteMusic.scrollFactor.set();
		txtMuteMusic.text = "Music";
		txtMuteMusic.color = FlxColor.PURPLE;
		
		txtMuteMusic.y = txtMuteSounds.y + txtMuteSounds.height + 24;
		
		btnCheckMusic = new FlxSprite();
		btnCheckMusic.frames = GraphicsCache.loadGraphicFromAtlas("checkbox", AssetPaths.checks__png, AssetPaths.checks__xml).atlasFrames;
		btnCheckMusic.animation.addByNames("check-off-off", ["check-off-off.png"]);
		btnCheckMusic.animation.addByNames("check-off-on", ["check-off-on.png"]);
		btnCheckMusic.animation.addByNames("check-on-on", ["check-on-on.png"]);
		btnCheckMusic.animation.addByNames("check-on-off", ["check-on-off.png"]);
		if (SoundSystem.volumeMusic == 0)
		{
			btnCheckMusic.animation.play("check-off-off");
		}
		else
		{
			btnCheckMusic.animation.play("check-on-off");
		}
		btnCheckMusic.scrollFactor.set();
		
		btnCheckMusic.y = txtMuteMusic.y + (txtMuteMusic.height / 2) - (btnCheckMusic.height / 2);
		
		
		btnCheckMusic.x = btnCheckSound.x =btnCheckFull.x = (FlxG.width / 2) - ((txtMuteSounds.width + 32 + btnCheckSound.width) / 2);
		txtMuteSounds.x = txtMuteMusic.x = txtFull.x = btnCheckFull.x + btnCheckFull.width + 32;
		
		
		add(title);
		add(txtFull);
		add(btnCheckFull);
		add(txtMuteSounds);
		add(btnCheckSound);
		add(txtMuteMusic);
		add(btnCheckMusic);
		
	}
	
	private function set_alpha(Value:Float):Float
	{
		if (Value < 0)
			alpha = 0;
		if (Value > 1)
			alpha = 1;
		alpha = Value;
		//back.alpha = title.alpha = btnYes.alpha = btnNo.alpha = txtNo.alpha = txtYes.alpha = alpha;
		blackOut.alpha = alpha * .66;
		return alpha;
	}
	
}