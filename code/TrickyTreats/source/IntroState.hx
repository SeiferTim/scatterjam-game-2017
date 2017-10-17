package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class IntroState extends FlxState
{
	private var madeIn:FlxSprite;
	private var fall:Bool = false;
	private var ggj:FlxSprite;
	private var jack:FlxSprite;
	private var hue:Float = 0;
	
	override public function create():Void 
	{
		
		Input.initialize();
		
		SoundSystem.initSound();
		
		FlxG.mouse.visible = false;
		bgColor = FlxColor.BLACK;
		
		madeIn = new FlxSprite(0, 0, AssetPaths.made_in_stl__png);
		madeIn.alpha = 0;
		madeIn.screenCenter(FlxAxes.XY);
		
		add(madeIn);
		
		jack = new FlxSprite(0, 0, AssetPaths.jack__png);
		jack.alpha = 0;
		jack.screenCenter();
		add(jack);
		
		ggj = new FlxSprite(0, 0, AssetPaths.tmt__png);
		ggj.screenCenter();
		ggj.alpha = 0;
		add(ggj);
		
		FlxTween.tween(madeIn, { "alpha":1 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:finishIn, startDelay: 1 } );
		
		
		super.create();
	}
	
	private function hueShift():Void
	{
		FlxTween.color(madeIn, .5, FlxColor.WHITE, FlxColor.ORANGE, {type:FlxTween.ONESHOT, startDelay: 2, onComplete:function(_){
			FlxTween.tween(jack, {alpha:1}, .5, {type:FlxTween.ONESHOT, onComplete:function(_) {
				finishSound();
			}});
		}});
	}
	
	private function finishIn(_):Void
	{
		hueShift();
		FlxG.sound.play(AssetPaths.madeinstl__wav, 1, false, SoundSystem.groupSound, true);// , finishSound);
		
	}
	
	
	
	private function finishSound():Void
	{
		FlxTween.tween(madeIn, { "alpha":0 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.quintOut, startDelay:1.5, onComplete:finishOut } );
	}
	
	private function finishOut(_):Void
	{
		
		FlxTween.tween(ggj, { "alpha":1 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.quintOut, onComplete:finishGGJIn } );

	}
	
	private function finishGGJIn(_):Void
	{
		jack.kill();
		FlxTween.tween(ggj, { "alpha":0 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.quintOut, startDelay:3, onComplete:finishGGJOut } );
		
	}
	
	private function finishGGJOut(_):Void
	{
		FlxG.switchState(new TitleState());
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		
		
		
		super.update(elapsed);
		
	}
	
}