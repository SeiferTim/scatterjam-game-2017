package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class IntroSubState extends FlxSubState 
{

	
	public var back:SliceSprite;
	public var text:FlxBitmapText;
	public var txtClose:FlxBitmapText;
	public var arrText:Array<String>;
	public var arrVO:Array<FlxSoundAsset>;
	public var currText:Int = 0;
	public var alpha(default, set):Float;
	private var ready:Bool = false;
	private var howTo:FlxSprite;
	private var musicWas:Float;
	private var started:Bool;
	private var sound:FlxSound;
	
	public function new() 
	{
		super(FlxColor.TRANSPARENT);
		
		
		arrText = [
						"It's Halloween Night!\nTime for Trick-or-Treat!\n...but something's not right\non your neighborhood street.",
						"There's too many kids,\nout here in the crowd.\nWearing masks to stay hid.\nIt should not be allowed!",
						"The answer is obvious:\nthey're here for our sweets!\nThere's monsters among us,\nwhom you must defeat!",
						"Talk to your peers,\nfind who's on your side.\nThey might say something weird\nif they've got something to hide.",
						"Their social skills are lacking,\nso give them a snack.\nSend them all packing\nwhen you catch them in the act.",
						"Of mistakes, be wary.\nDo not falsely accuse.\nThey'll take some of your candy,\nand, if you run out, you'll lose!",
						"It's Monster Masks!"
				];
		
		arrVO = [
					AssetPaths.vo01__wav,
					AssetPaths.vo02__wav,
					AssetPaths.vo03__wav,
					AssetPaths.vo04__wav,
					AssetPaths.vo05__wav,
					AssetPaths.vo06__wav,
					AssetPaths.vo07__wav
				];
				
				
		back = new SliceSprite(AssetPaths.story_frame__png, new FlxRect(15, 15, 19, 14), 49, 48);
		
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		text = new FlxBitmapText(font_light);
		text.scrollFactor.set();
		text.text = arrText[currText];
		
		text.multiLine = true;
		
		text.color = FlxColor.ORANGE;
		text.alignment = "center";
		text.screenCenter();
		
		
		
		txtClose = new FlxBitmapText(font_light);
		txtClose.scrollFactor.set();
		txtClose.text = "Press Z To Skip";
		txtClose.color = FlxColor.CYAN;
		txtClose.alignment = "center";
		txtClose.screenCenter(FlxAxes.X);
		txtClose.y = FlxG.height - txtClose.height - 32;
		
		back.scrollFactor.set();
		back.x = text.x - 64;
		back.y = text.y - 64;
		back.width = text.width + 128;
		back.height = text.height + 128;
		
		
		
		add(back);
		add(text);
		add(txtClose);
		
		
		alpha = 0;
		
		
		FlxTween.tween(this, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:finishFadeIn});
		
		
	}
	
	private function finishFadeIn(_):Void
	{
		ready = true;

		
		
		
	}
	
	private function playNextSound():Void
	{
		if (!ready)
			return;
		currText++;
		if (currText >= arrText.length)
		{
			
			FlxTween.tween(this, {alpha:0}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:function(_) {
				SoundSystem.fadeMusic(.5, musicWas);
				howTo = new FlxSprite(0, 0, AssetPaths.how_to_play__png);
				howTo.alpha = 0;
				add(howTo);
				txtClose.text = "Press Z to Close";
				txtClose.screenCenter(FlxAxes.X);
				FlxTween.tween(this, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut});
			}});
		}
		else
		{
			FlxTween.tween(this, {alpha:0},.33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:function(_) {
				text.text = arrText[currText];
				text.screenCenter();
				back.x = text.x - 64;
				back.y = text.y - 64;
				back.width = text.width + 128;
				back.height = text.height + 128;
				
				
				FlxTween.tween(this, {alpha:1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:function(_) {
					sound = FlxG.sound.play(arrVO[currText], 1, false, SoundSystem.groupSound, true, playNextSound);
				}});
			}});
		}
	}
	
	
	
	private function set_alpha(Value:Float):Float
	{
		if (Value < 0)
			alpha = 0;
		if (Value > 1)
			alpha = 1;
		alpha = Value;
		if (howTo != null)
		{
			howTo.alpha = alpha;
		}
		else
		{	
			text.alpha = back.alpha = alpha;
		}
		txtClose.alpha = alpha;
		
		return alpha;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		
		
		Input.update(elapsed);
		
		super.update(elapsed);

		if (ready)
		{
			if (!started)
			{
				
				if (SoundSystem.music != null)
				{
					if (SoundSystem.music.playing && SoundSystem.music.exists)
					{
						musicWas = SoundSystem.music.volume;
						SoundSystem.fadeMusic(.5, musicWas * .1);
						started = true;
						var t:FlxTimer = new FlxTimer();
						t.start(.5,function (_)
						{
					
							sound = FlxG.sound.play(arrVO[currText], 1, false, SoundSystem.groupSound, true, playNextSound);
						});
					}
				
				}
			}
			else
			{

				if (Input.A_Button[Input.JUST_RELEASED] || Input.B_Button[Input.JUST_RELEASED] || Input.C_Button[Input.JUST_RELEASED] || Input.Start[Input.JUST_RELEASED])
				{
					exitSubstate();
				}	
			}
		}
	
		
	}
	
	private function exitSubstate():Void
	{
		ready = false;
		
		if (sound != null)
		{
			if (sound.exists)
			{
				if (sound.playing)
				{
					sound.fadeOut(.33, 0, function(_) {
						finishExit();
					});
				}
			}
			
		}
		
		
		
	}
	
	private function finishExit():Void
	{
		SoundSystem.fadeMusic(.5, musicWas);
		FlxTween.tween(this, {alpha:0},.5, {type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut, onComplete:finishFadeOut});
	}
	
	private function finishFadeOut(_):Void
	{
		close();
	}
}