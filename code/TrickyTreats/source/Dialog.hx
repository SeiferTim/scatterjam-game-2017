package;

import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.addons.display.FlxSliceSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;


class Dialog extends FlxGroup 
{

	public var text:FlxBitmapText;
	public var box:FlxSliceSprite;
	public var hint:FlxBitmapText;
	public var parent:PlayState;
	public var ready:Bool = false;
	public var gave:Bool = false;
	private var newText:String;
	public var thought:FlxSliceSprite;
	//public var candyCount:FlxBitmapText;
	
	public var alpha(default, set):Float = 0;
	
	public function new(Parent:PlayState) 
	{
		super();
		
		parent = Parent;
		
		
		
		var font_dark:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_dark_export__png, AssetPaths.custom_font_dark_export__xml);
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_export__png, AssetPaths.custom_font_light_export__xml);
		
		box = new SliceSprite(AssetPaths.word_balloon_2__png, new FlxRect(38, 12, 54, 46), 104, 104);  
		
		add(box);
		
		text = new FlxBitmapText(font_dark);
		text.autoSize = false;
		text.multiLine = true;
		text.wordWrap = true;
		
		
		add(text);
		
		thought = new SliceSprite(AssetPaths.thought_balloon__png, new FlxRect(20, 21, 59, 60), 101, 102);
		add(thought);
		
		hint = new FlxBitmapText(font_light);
		
		hint.color = FlxColor.BLUE;
		
		
		add(hint);
		
		/*candyCount = new FlxBitmapText(font_light);
		candyCount.text = Std.string(parent.playerCandy);
		candyCount.color = FlxColor.PURPLE;
		add(candyCount);*/
		
		
		alpha = 0.01;
		
	}
	
	public function show(Target:KidBody, Text:String):Void
	{
		text.text = Text;
		text.x = Target.x + Target.width + 12;
		text.fieldWidth = Std.int((FlxG.width / 4) - 200);
		
		text.y = Target.y - 96;
		
		text.draw();
		
		box.x = text.x - 8;
		box.y = text.y - 8;
		box.width = text.width + 16;
		box.height = text.height + 50;
		
		
		
		hint.text = "Z = Leave\nX = Give\nC = Accuse";
		hint.multiLine = true;
		hint.wordWrap = true;
		hint.x = box.x + (box.width / 2) - (hint.width / 2);
		hint.y = box.y + box.height - 24;
		
		thought.x = hint.x - 12;
		thought.y = hint.y -12;
		thought.width = hint.width + 24;
		thought.height = hint.height + 24;
		
		//candyCount.x = FlxG.camera.totalScaleX;
		//candyCount.y = FlxG.camera.totalScaleY;
		
		FlxTween.tween(this, {alpha: 1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:finishFadeIn});
		
	}
	
	public function switchText(NewText:String):Void
	{
		ready = false;
		newText = NewText;
		gave = true;
		FlxTween.tween(this, {alpha: 0.01}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:finishSwitchOut});
	}
	
	private function finishSwitchOut(_):Void
	{
		text.text = newText;
		//text.x = Target.x + Target.width + 12;
		text.fieldWidth = Std.int((FlxG.width / 4) - 200);
		
		//text.y = Target.y - 72;
		
		text.draw();
		
		box.x = text.x - 8;
		box.y = text.y - 8;
		box.width = text.width + 16;
		box.height = text.height + 50;
		
		hint.text = "Z = Leave\nC = Accuse";
		hint.multiLine = true;
		hint.wordWrap = true;
		hint.x = box.x + (box.width / 2) - (hint.width / 2);
		hint.y = box.y + box.height - 24;
		
		thought.x = hint.x - 12;
		thought.y = hint.y -12;
		thought.width = hint.width + 24;
		thought.height = hint.height + 24;
		
		//candyCount.text = Std.string(parent.playerCandy);
		
		//candyCount.x = FlxG.camera.scroll.x * 4;
		//candyCount.y = FlxG.camera.scroll.y * 4;
		
		FlxTween.tween(this, {alpha: 1}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:finishFadeIn});
		
	}
	
	private function set_alpha(Value:Float):Float
	{
		if (Value > 1)
			Value = 1;
		else if (Value <= 0)
			Value = 0.01;
		alpha = Value;
		thought.alpha = hint.alpha = text.alpha = box.alpha = Value; //candyCount.alpha = 
		return Value;
	}
	
	private function finishFadeIn(_):Void
	{
		ready = true;
	}
	
	public function close():Void
	{
		gave = false;
		ready = false;
		FlxTween.tween(this, {alpha: 0.01}, .33, {type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:finishFadeOut});
	}
	
	private function finishFadeOut(_):Void
	{
		
		parent.doneTalking();
	}
	
}

