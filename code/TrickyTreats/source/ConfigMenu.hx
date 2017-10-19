package;

import axollib.GraphicsCache;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
	private var btnClose:FlxSprite;
	
	private var ready:Bool = false;
	private var blackOut:FlxSprite;
	private var alpha(default, set):Float;
	private var mousePoint:FlxPoint;
	private var hudCam:FlxCamera;
	
	
	public function new(CallBack:Void->Void, ?HudCamera:FlxCamera = null) 
	{
		super(FlxColor.TRANSPARENT);
		
		if (HudCamera == null)
			hudCam = FlxG.camera;
		else
			hudCam = HudCamera;
		
		mousePoint = FlxPoint.get();
		
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
		title.y = (FlxG.height / 2) - ((title.height + 32) * 2);
		
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
		btnCheckSound.frames = GraphicsCache.loadGraphicFromAtlas("sound-icons", AssetPaths.sound_icons__png, AssetPaths.sound_icons__xml).atlasFrames;
		btnCheckSound.animation.addByNames("sound-off-off", ["sound-off-off.png"]);
		btnCheckSound.animation.addByNames("sound-low-off", ["sound-low-off.png"]);
		btnCheckSound.animation.addByNames("sound-mid-off", ["sound-mid-off.png"]);
		btnCheckSound.animation.addByNames("sound-full-off", ["sound-full-off.png"]);
		btnCheckSound.animation.addByNames("sound-off-on", ["sound-off-on.png"]);
		btnCheckSound.animation.addByNames("sound-low-on", ["sound-low-on.png"]);
		btnCheckSound.animation.addByNames("sound-mid-on", ["sound-mid-on.png"]);
		btnCheckSound.animation.addByNames("sound-full-on", ["sound-full-on.png"]);
		
		switch(SoundSystem.volumeSound)
		{
			case 0:
				btnCheckSound.animation.play("sound-off-off");
				
			case .33:
				btnCheckSound.animation.play("sound-low-off");
				
			case .66:
				btnCheckSound.animation.play("sound-mid-off");
				
			case 1:
				btnCheckSound.animation.play("sound-full-off");
				
				
		}
		
		
		btnCheckSound.scrollFactor.set();
		
		btnCheckSound.y = txtMuteSounds.y + (txtMuteSounds.height / 2) - (btnCheckSound.height / 2);
		
		txtMuteMusic = new FlxBitmapText(font_light);
		txtMuteMusic.scrollFactor.set();
		txtMuteMusic.text = "Music";
		txtMuteMusic.color = FlxColor.PURPLE;
		
		txtMuteMusic.y = txtMuteSounds.y + txtMuteSounds.height + 24;
		
		btnCheckMusic = new FlxSprite();
		btnCheckMusic.frames = GraphicsCache.loadGraphicFromAtlas("sound-icons", AssetPaths.sound_icons__png, AssetPaths.sound_icons__xml).atlasFrames;
		btnCheckMusic.animation.addByNames("sound-off-off", ["sound-off-off.png"]);
		btnCheckMusic.animation.addByNames("sound-low-off", ["sound-low-off.png"]);
		btnCheckMusic.animation.addByNames("sound-mid-off", ["sound-mid-off.png"]);
		btnCheckMusic.animation.addByNames("sound-full-off", ["sound-full-off.png"]);
		btnCheckMusic.animation.addByNames("sound-off-on", ["sound-off-on.png"]);
		btnCheckMusic.animation.addByNames("sound-low-on", ["sound-low-on.png"]);
		btnCheckMusic.animation.addByNames("sound-mid-on", ["sound-mid-on.png"]);
		btnCheckMusic.animation.addByNames("sound-full-on", ["sound-full-on.png"]);
		
		switch(SoundSystem.volumeMusic)
		{
			case 0:
				btnCheckMusic.animation.play("sound-off-off");
				
			case .33:
				btnCheckMusic.animation.play("sound-low-off");
				
			case .66:
				btnCheckMusic.animation.play("sound-mid-off");
				
			case 1:
				btnCheckMusic.animation.play("sound-full-off");
				
				
		}
		btnCheckMusic.scrollFactor.set();
		
		btnCheckMusic.y = txtMuteMusic.y + (txtMuteMusic.height / 2) - (btnCheckMusic.height / 2);
		
		
		btnCheckMusic.x = btnCheckSound.x =btnCheckFull.x = (FlxG.width / 2) - ((txtMuteSounds.width + 32 + btnCheckSound.width) / 2);
		txtMuteSounds.x = txtMuteMusic.x = txtFull.x = btnCheckFull.x + btnCheckFull.width + 32;
		
		
		btnClose = new FlxSprite();
		btnClose.frames = GraphicsCache.loadGraphicFromAtlas("dark-close", AssetPaths.dark_close__png, AssetPaths.dark_close__xml).atlasFrames;
		btnClose.animation.addByNames("close-up", ["dark_close_up.png"]);
		btnClose.animation.addByNames("close-off", ["dark_close_off.png"]);
		btnClose.animation.play("close-off");
		btnClose.scrollFactor.set();
		
		
		
		
		back = new SliceSprite(AssetPaths.thought_balloon__png, new FlxRect(20, 21, 59, 60), 101, 102);
		back.scrollFactor.set();
		back.x = btnCheckSound.x - 64;
		back.y = title.y - 64;
		back.width = (txtMuteSounds.width + 32 + btnCheckSound.width) + 128;
		back.height = (txtMuteMusic.y + txtMuteMusic.height + 64) - (title.y - 64);
		
		btnClose.x = back.x+back.width-(btnClose.width*1.5);
		btnClose.y = back.y+(btnClose.height*.5);
		
		add(back);
		
		add(title);
		add(txtFull);
		add(btnCheckFull);
		add(txtMuteSounds);
		add(btnCheckSound);
		add(txtMuteMusic);
		add(btnCheckMusic);
		add(btnClose);
		
		camera = back.camera = title.camera = txtFull.camera = btnCheckFull.camera = txtMuteMusic.camera = txtMuteSounds.camera = btnCheckSound.camera = txtMuteMusic.camera = btnCheckMusic.camera = btnClose.camera = hudCam;
		cameras = back.cameras = title.cameras = txtFull.cameras = btnCheckFull.cameras = txtMuteMusic.cameras = txtMuteSounds.cameras = btnCheckSound.cameras = txtMuteMusic.cameras = btnCheckMusic.cameras = btnClose.cameras = [hudCam];
		
		alpha = 0;
		
		
		FlxTween.tween(this, {alpha:1},.33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:finishFadeIn});
		
	}
	
	private function finishFadeIn(_):Void
	{
		ready = true;
	}
	
	private function set_alpha(Value:Float):Float
	{
		if (Value < 0)
			alpha = 0;
		if (Value > 1)
			alpha = 1;
		alpha = Value;
		
		btnClose.alpha = back.alpha = title.alpha = txtMuteMusic.alpha = txtMuteSounds.alpha = btnCheckMusic.alpha = btnCheckSound.alpha = txtFull.alpha = btnCheckFull.alpha = alpha;
		
		blackOut.alpha = alpha * .66;
		return alpha;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		Input.update(elapsed);
		FlxG.mouse.getScreenPosition(hudCam, mousePoint);
		
		if (btnCheckFull.overlapsPoint(mousePoint))
		{
			if (FlxG.fullscreen)
				btnCheckFull.animation.play("check-on-on");
			else
				btnCheckFull.animation.play("check-off-on");
			if (FlxG.mouse.justReleased && ready)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				FlxG.fullscreen = !FlxG.fullscreen;
			}
		}
		else
		{
			if (FlxG.fullscreen)
				btnCheckFull.animation.play("check-on-off");
			else
				btnCheckFull.animation.play("check-off-off");
		}
		
		if (btnCheckMusic.overlapsPoint(mousePoint))
		{
			switch(SoundSystem.volumeMusic)
			{
				case 0:
					btnCheckMusic.animation.play("sound-off-on");
					
				case .33:
					btnCheckMusic.animation.play("sound-low-on");
					
				case .66:
					btnCheckMusic.animation.play("sound-mid-on");
					
				case 1:
					btnCheckMusic.animation.play("sound-full-on");
			}
			if (FlxG.mouse.justReleased && ready)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				switch(SoundSystem.volumeMusic)
				{
					case 0:
						SoundSystem.volumeMusic = 1;
						
					case .33:
						SoundSystem.volumeMusic = 0;
						
					case .66:
						SoundSystem.volumeMusic = .33;
						
					case 1:
						SoundSystem.volumeMusic = .66;
				}
				
			}
		}
		else
		{
			switch(SoundSystem.volumeMusic)
			{
				case 0:
					btnCheckMusic.animation.play("sound-off-off");
					
				case .33:
					btnCheckMusic.animation.play("sound-low-off");
					
				case .66:
					btnCheckMusic.animation.play("sound-mid-off");
					
				case 1:
					btnCheckMusic.animation.play("sound-full-off");
			}
		}
		
		if (btnCheckSound.overlapsPoint(mousePoint))
		{
			switch(SoundSystem.volumeSound)
			{
				case 0:
					btnCheckSound.animation.play("sound-off-on");
					
				case .33:
					btnCheckSound.animation.play("sound-low-on");
					
				case .66:
					btnCheckSound.animation.play("sound-mid-on");
					
				case 1:
					btnCheckSound.animation.play("sound-full-on");
			}
			if (FlxG.mouse.justReleased && ready)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				switch(SoundSystem.volumeSound)
				{
					case 0:
						SoundSystem.volumeSound = 1;
						
					case .33:
						SoundSystem.volumeSound = 0;
						
					case .66:
						SoundSystem.volumeSound = .33;
						
					case 1:
						SoundSystem.volumeSound = .66;
				}
				FlxG.sound.play(AssetPaths.hey__wav, 1, false, SoundSystem.groupSound);
			}
		}
		else
		{
			switch(SoundSystem.volumeSound)
			{
				case 0:
					btnCheckSound.animation.play("sound-off-off");
					
				case .33:
					btnCheckSound.animation.play("sound-low-off");
					
				case .66:
					btnCheckSound.animation.play("sound-mid-off");
					
				case 1:
					btnCheckSound.animation.play("sound-full-off");
			}
		}
		
		if (btnClose.overlapsPoint(mousePoint))
		{
			btnClose.animation.play("close-up");
			if (FlxG.mouse.justReleased && ready)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				exitSubstate();
			}
		}
		else
		{
			btnClose.animation.play("close-off");
		}
		
		super.update(elapsed);
	}
	
	private function exitSubstate():Void
	{
		ready = false;
		
		FlxTween.tween(this, {alpha:0},.33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:finishFadeOut});
		
	}
	
	private function finishFadeOut(_):Void
	{
		close();
	}
	
	override public function destroy():Void 
	{
		
		super.destroy();
	}
}