package;


import axollib.GraphicsCache;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

class MainUI extends FlxGroup 
{

	
	public var hudCam:FlxCamera;
	public var btnClose:FlxSprite;
	public var btnScreen:FlxSprite;
	public var btnConfig:FlxSprite;
	public var mousePoint:FlxPoint;
	public var wait:Bool = false;
	
	public function new(?HudCam:FlxCamera = null) 
	{
		
		super(3);
		
		
		
		if (HudCam == null)
		{
			hudCam = FlxG.camera;
		}
		else
		{
			hudCam = HudCam;
		}
		
		camera = hudCam;
		cameras = [hudCam];
		
		btnClose = new FlxSprite();
		btnClose.frames = GraphicsCache.loadGraphicFromAtlas("buttons", AssetPaths.buttons__png, AssetPaths.buttons__xml).atlasFrames;
		btnClose.animation.addByNames("close-up", ["close_up.png"]);
		btnClose.animation.addByNames("close-off", ["close_off.png"]);
		btnClose.animation.play("close-off");
		btnClose.scrollFactor.set();
		btnClose.x = FlxG.width - btnClose.width - 16;
		btnClose.y = 24;
		btnClose.camera = hudCam;
		btnClose.cameras = [hudCam];
		
		add(btnClose);
		
		btnScreen = new FlxSprite();
		btnScreen.frames = GraphicsCache.loadGraphicFromAtlas("buttons", AssetPaths.buttons__png, AssetPaths.buttons__xml).atlasFrames;
		btnScreen.animation.addByNames("max-up", ["maximize_up.png"]);
		btnScreen.animation.addByNames("max-off", ["maximize_off.png"]);
		btnScreen.animation.addByNames("res-up", ["restore_up.png"]);
		btnScreen.animation.addByNames("res-off", ["restore_off.png"]);
		if (FlxG.fullscreen)
			btnScreen.animation.play("res-off");
		else
			btnScreen.animation.play("max-off");
		btnScreen.scrollFactor.set();
		btnScreen.y = 24;
		btnScreen.x = btnClose.x - btnScreen.width - 16;
		btnScreen.camera = hudCam;
		btnScreen.cameras = [hudCam];
		add(btnScreen);
		
		btnConfig = new FlxSprite();
		btnConfig.frames = GraphicsCache.loadGraphicFromAtlas("buttons", AssetPaths.buttons__png, AssetPaths.buttons__xml).atlasFrames;
		btnConfig.animation.addByNames("config-up", ["config_up.png"]);
		btnConfig.animation.addByNames("config-off", ["config_off.png"]);
		btnConfig.animation.play("config-off");
		btnConfig.scrollFactor.set();
		btnConfig.x = btnScreen.x - btnConfig.width - 16;
		btnConfig.y = 24;
		btnConfig.camera = hudCam;
		btnConfig.cameras = [hudCam];
		add(btnConfig);
		
		mousePoint = FlxPoint.get();
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		
		FlxG.mouse.getScreenPosition(hudCam, mousePoint);
		if (btnClose.overlapsPoint(mousePoint))
		{
			btnClose.animation.play("close-up");
			if (FlxG.mouse.justReleased)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				closeMenu();
			}
		}
		else
		{
			btnClose.animation.play("close-off");
		}
		
		if (btnConfig.overlapsPoint(mousePoint))
		{
			btnConfig.animation.play("config-up");
			if (FlxG.mouse.justReleased)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				configMenu();
			}
		}
		else
		{
			btnConfig.animation.play("config-off");
		}
		
		if (btnScreen.overlapsPoint(mousePoint))
		{
			
			if (FlxG.fullscreen)
			{
				btnScreen.animation.play("res-up");
			}
			else
			{
				btnScreen.animation.play("max-up");
			}
			if (FlxG.mouse.justReleased)
			{
				FlxG.sound.play(AssetPaths.click__wav, 1, false, SoundSystem.groupSound);
				switchFullScreen();
			}
			
		}
		else
		{
			if (FlxG.fullscreen)
			{
				btnScreen.animation.play("res-off");
			}
			else
			{
				btnScreen.animation.play("max-off");
			}
		}
		
		
		if (FlxG.mouse.visible)
		{
			btnConfig.alpha = btnClose.alpha = btnScreen.alpha = 1;
		}
		else
		{
			btnConfig.alpha = btnClose.alpha = btnScreen.alpha = .33;
		}
		
		
		
		super.update(elapsed);
	}
	
	public function closeMenu():Void
	{
		if (wait)
			return;
		wait = true;
		FlxG.state.openSubState(new QuitMenu(returnFromMenu, hudCam));
		
		
		
	}
	
	private function configMenu():Void
	{
		if (wait)
			return;
		wait = true;
		FlxG.state.openSubState(new ConfigMenu(returnFromMenu, hudCam));
	}
	
	private function switchFullScreen():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
	}
	
	private function returnFromMenu():Void
	{
		wait = false;
	}
	
	
	override public function destroy():Void 
	{
		mousePoint.put();
		mousePoint = FlxDestroyUtil.destroy(mousePoint);
		super.destroy();
	}
	

}