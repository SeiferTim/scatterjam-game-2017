package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.math.FlxMath;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.util.FlxSave;
import lime.ui.Window;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.system.Capabilities;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.autoPause = false;

		var s:FlxSave = new FlxSave();
		s.bind("monstermasks-misc-save");

		if (s.data.full == null)
		{
			s.data.full = false;
		}

		addChild(new FlxGame(1600, 900, IntroState, 1, 60, 60, true, s.data.full));

		FlxG.sound.soundTrayEnabled = false;
		FlxG.scaleMode = new RatioScaleMode();

		#if desktop
		var w:Int = FlxMath.MIN_VALUE_INT;
		var h:Int = FlxMath.MIN_VALUE_INT;
		if (s.data.screenw == null || s.data.screenh == null)
		{
			// find best resolution
			for (r in Reg.resolutions)
			{
				if (r.width > w && r.width <= Lib.application.window.width && r.height > h && r.height <= Lib.application.window.height)
				{
					w = r.width;
					h = r.height;
				}
			}
			s.data.screenw = w;
			s.data.screehw = h;
		}
		else
		{
			w = s.data.screenw;
			h = s.data.screenh;
		}
		s.flush();

		if (!FlxG.fullscreen)
			Reg.resize(w, h);

		#end

	}

}
