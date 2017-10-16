package;

import axollib.GraphicsCache;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class QuitMenu extends FlxSubState 
{

	
	private var back:SliceSprite;
	private var title:FlxBitmapText;
	private var txtYes:FlxBitmapText;
	private var txtNo:FlxBitmapText;
	private var btnYes:FlxSprite;
	private var btnNo:FlxSprite;
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
		
		btnYes = new FlxSprite();
		btnYes.frames = GraphicsCache.loadGraphicFromAtlas("candy_buttons", AssetPaths.candy_buttons__png, AssetPaths.candy_buttons__xml).atlasFrames;
		btnYes.animation.addByNames("yes-up", ["light_green_candy.png"]);
		btnYes.animation.addByNames("yes-off", ["green_candy.png"]);
		btnYes.animation.play("yes-off");
		btnYes.scrollFactor.set();
		btnYes.x = (FlxG.width / 2) - btnYes.width - 32;
		btnYes.y = (FlxG.height / 2) + 32;
		
		btnNo = new FlxSprite();
		btnNo.frames = GraphicsCache.loadGraphicFromAtlas("candy_buttons", AssetPaths.candy_buttons__png, AssetPaths.candy_buttons__xml).atlasFrames;
		btnNo.animation.addByNames("no-up", ["light_red_candy.png"]);
		btnNo.animation.addByNames("no-off", ["red_candy.png"]);
		btnNo.animation.play("no-off");
		btnNo.scrollFactor.set();
		btnNo.x = (FlxG.width / 2) + 32;
		btnNo.y = (FlxG.height / 2) + 32;
		
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		title = new FlxBitmapText(font_light);
		title.scrollFactor.set();
		title.text = "Exit?";
		title.color = FlxColor.PURPLE;
		title.screenCenter(FlxAxes.X);
		title.y = (FlxG.height / 2) - title.height - 32;
		
		txtYes = new FlxBitmapText(font_light);
		txtYes.scrollFactor.set();
		txtYes.text = "Yes";
		txtYes.color = FlxColor.CYAN;
		txtYes.x =  btnYes.x + (btnYes.width / 2) - (txtYes.width / 2);
		txtYes.y =  btnYes.y + (btnYes.height / 2) - (txtYes.height / 2);
	
		txtNo = new FlxBitmapText(font_light);
		txtNo.scrollFactor.set();
		txtNo.text = "No";
		txtNo.color = FlxColor.ORANGE;
		txtNo.x =  btnNo.x + (btnNo.width / 2) - (txtNo.width / 2);
		txtNo.y =  btnNo.y + (btnNo.height / 2) - (txtNo.height / 2);
		
		back = new SliceSprite(AssetPaths.thought_balloon__png, new FlxRect(20, 21, 59, 60), 101, 102);
		back.scrollFactor.set();
		back.x = btnYes.x - 64;
		back.y = title.y - 64;
		back.width = (btnNo.x + btnNo.width + 64) - (btnYes.x - 64);
		back.height = (btnYes.y + btnYes.height + 64) - (title.y - 64);
		
		add(back);
		add(title);
		add(btnYes);
		add(btnNo);
		add(txtNo);
		add(txtYes);
		
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
		back.alpha = title.alpha = btnYes.alpha = btnNo.alpha = txtNo.alpha = txtYes.alpha = alpha;
		blackOut.alpha = alpha * .66;
		return alpha;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		Input.update(elapsed);
		
		if (FlxG.mouse.overlaps(btnYes))
		{
			btnYes.animation.play("yes-up");
			if (FlxG.mouse.justReleased && ready)
			{
				System.exit(0);
				
			}
		}
		else
		{
			btnYes.animation.play("yes-off");
		}
		
		if (FlxG.mouse.overlaps(btnNo))
		{
			btnNo.animation.play("no-up");
			if (FlxG.mouse.justReleased && ready)
			{
				exitSubstate();
				
			}
		}
		else
		{
			btnNo.animation.play("no-off");
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
	
}