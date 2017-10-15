package;

import flash.net.SharedObject;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxZoomCamera;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import openfl.Assets;


class PlayState extends FlxState
{
	
	public static inline var MAX_MASKS:Int = 26;
	public static inline var MONST_COUNT:Int = 3;
	public static inline var KID_COUNT:Int = 8;
	
	public static inline var KIDS:Int = 0;
	public static inline var MONST:Int = 1;
	public var masks:Array<Int>;
	public var lines = [[], []];
	
	public var kids:FlxGroup;
	public var player:KidBody;
	public var targeting:KidBody;
	public var target:FlxSprite;
	public var dialog:Dialog;
	public var shadows:FlxGroup;
	public var accusing:Bool;
	
	public var candyCounter:FlxBitmapText;
	
	public var playerCandy(default, set):Int = 10;
	
	public var hudCam:FlxCamera;
	public var mainCam:FlxCamera;
	
	public var music:FlxSound;
	public var monstersCaught:Int = 0;
	
	override public function create():Void
	{
		super.create();
		
		mainCam = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
		hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
		hudCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(mainCam);
		FlxG.cameras.add(hudCam);
		FlxG.camera = mainCam;
		FlxCamera.defaultCameras = [mainCam];
		
		
		//var font_dark:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_dark_export__png, AssetPaths.custom_font_dark_export__xml);
		var font_light:FlxBitmapFont = FlxBitmapFont.fromAngelCode(AssetPaths.custom_font_light_normal_export__png, AssetPaths.custom_font_light_normal_export__xml);
		
		readLines();
		
		var bg:FlxSprite = new FlxSprite(0, 0, AssetPaths.background_graphic_composite__png);
		bg.screenCenter();
		
		add(bg);
		
		FlxG.camera.setScrollBounds( -40, FlxG.width + 40, -40, FlxG.height +40);
		FlxG.camera.style  = FlxCameraFollowStyle.TOPDOWN;
		FlxG.worldBounds.set( 200, (FlxG.height / 2)+120, FlxG.width - 400, (FlxG.height / 2) - 120);
		
		
		shadows = new FlxGroup();
		add(shadows);
		
		kids = new FlxGroup();
		add(kids);
		
		var k:KidBody;
		masks = [];
		
		for (i in 0...MAX_MASKS)
		{
			masks.push(i);
		}
		
		FlxG.random.shuffle(masks);
		/*masks.unshift(25);
		masks.unshift(24);
		masks.unshift(23);*/
		
		for (i in 0...KID_COUNT)
		{
			k = new KidBody(this,  FlxG.random.float(120, FlxG.width - 120), FlxG.random.float(FlxG.height / 2, FlxG.height - 120), masks[i],false, false, .001 * i);
			kids.add(k);
			kids.add(k.head);
			
		}
		
		for (i in 0...MONST_COUNT)
		{
			k = new KidBody(this,  FlxG.random.float(120, FlxG.width - 120), FlxG.random.float(FlxG.height / 2, FlxG.height - 120), masks[i + KID_COUNT], false, true, .001 * (i+KID_COUNT));
			trace(k.head.animation.frameName);
			kids.add(k);
			kids.add(k.head);
			
		}
		
		player = new KidBody(this, FlxG.random.float(120, FlxG.width - 120), FlxG.random.float(FlxG.height / 2, FlxG.height - 120), masks[KID_COUNT+MONST_COUNT], true,false,  .001 * (KID_COUNT+MONST_COUNT));
		kids.add(player);
		kids.add(player.head);
		
		FlxG.camera.target = player;
		
		target = new FlxSprite();
		target.loadGraphic(AssetPaths.target__png);
		target.visible = false;
		add(target);
		
		dialog = new Dialog(this);
		add(dialog);
		
		
		
		
		candyCounter = new FlxBitmapText(font_light);
		candyCounter.text = "10";
		candyCounter.scrollFactor.set();
		candyCounter.color = FlxColor.PURPLE;
		candyCounter.x = 24;
		candyCounter.y = FlxG.height - candyCounter.height - 24;
		candyCounter.camera = hudCam;
		candyCounter.cameras = [hudCam];
		
		
		add(candyCounter);
		
		
		SoundSystem.playMusic(AssetPaths.Halloween_Fun__mp3, -1, AssetPaths.Halloween_Fun__mp3);
		
	}
	
	private function readLines():Void
	{
		var current:Int = KIDS;
		var line:String;
		
		var data:Array<String> = Assets.getText(AssetPaths.Words__txt).split("\r\n");
		for (l in data)
		{
			if (l == "-kids")
			{
				
			}
			else if (l == "-monsters")
			{
				current = MONST;
			}
			else if (l != '')
			{
				lines[current].push(l);
			}
		}
	}
	
	override public function draw():Void 
	{
		
		sortKids();
		super.draw();
	}

		
	override public function update(elapsed:Float):Void
	{
		Input.update(elapsed);
		
		super.update(elapsed);
		
		
		determineTarget();
		
		if (player.talking)
		{
			if (dialog.ready)
			{
				if (Input.A_Button[Input.JUST_RELEASED])
				{
					dialog.close();
				}
				else if (Input.B_Button[Input.JUST_RELEASED] && !dialog.gave)
				{
					targeting.tiredness += .4;
					playerCandy--;
					candyCounter.text = Std.string(playerCandy);
					dialog.switchText(getKidLine(targeting));
				}
				else if (Input.C_Button[Input.JUST_RELEASED])
				{
					
					accusing = true;
					dialog.close();
					
					
				}
			}
		}
		else
		{
			if (targeting != null && Input.A_Button[Input.JUST_PRESSED])
			{
				target.visible = false;
				targeting.talking = player.talking = true;
				
				FlxG.camera.target = targeting.cameraFocus;
				
				FlxTween.tween(FlxG.camera, {zoom:4}, .33, {ease:FlxEase.sineOut, type:FlxTween.ONESHOT, onComplete:doneZoomIn});
			}
		}
		
	}
	
	private function doneZoomIn(_):Void
	{
	
		if (targeting.isMonster)
			targeting.tiredness += .1;
		dialog.show(targeting, getKidLine(targeting));
		
	}
	
	public function getKidLine(K:KidBody):String
	{
		var which:Int = KIDS;
		
		if (K.isMonster)
		{
			
			if (FlxG.random.bool(K.tiredness * 100))
				which = MONST;
		}
		
		return FlxG.random.getObject(lines[which]);
	}
	
	
	public function doneTalking():Void
	{
		
		FlxTween.tween(FlxG.camera, {zoom:1}, .33, {ease:FlxEase.sineOut, type:FlxTween.ONESHOT, onComplete:doneZoomOut});
		
	}
	
	private function doneZoomOut(_):Void
	{
		FlxG.camera.target = player;
		
		
		if (accusing)
		{
			accusing = false;
			if (targeting.isMonster)
			{
				targeting.kill();
				playerCandy += 10;
				candyCounter.text = Std.string(playerCandy);
				targeting = null;
				player.talking = false;
				monstersCaught++;
				if (monstersCaught >= MONST_COUNT)
					GameWin();
				
			}
			else
			{
				playerCandy -= 5;
				candyCounter.text = Std.string(playerCandy);
				player.talking = targeting.talking = false;
			}
		}
		else
		{
			player.talking = targeting.talking = false;
		}
	}
	
	private function determineTarget():Void
	{
		if (player.talking)
			return;
		var best:KidBody=null;
		var bestD:Float = Math.POSITIVE_INFINITY;
		if (targeting != null)
		{
			if (targeting.alive && targeting.exists)
			{
				best = targeting;
				bestD = FlxMath.distanceBetween(player, best);
			}
		}
		
		for (i in kids)
		{
			
			if (Type.getClass(i) == KidBody && i != player && i.alive && i.exists)
			{
				var k:KidBody = cast i;
				var d:Float = FlxMath.distanceBetween(player, k);
				if (d < bestD)
				{
					best = k;
					bestD = d;
				}
			}
		}
		
		if (bestD < 140)
		{
			targeting = best;
			target.visible = true;
			target.x = targeting.baseX - (target.width / 2);
			target.y = targeting.baseY - 200;
		}
		else
		{
			targeting = null;
			target.visible = false;
		}
		
	}
	
	
	private function sortKids():Void
	{
		
		var kidsArr:Array<KidBody> = [];
		for (i in 0...kids.members.length)
		{
			if (Type.getClass(kids.members[i]) == KidBody)
			{
				kidsArr.push(cast kids.members[i]);
			}
		}
		kidsArr.sort(sortByBaseY);
		kids.members = [];
		for (i in 0...kidsArr.length)
		{
			kids.members.push(kidsArr[i]);
			kids.members.push(kidsArr[i].head);
		}
	}
	
	private function sortByBaseY(Obj1:KidBody, Obj2:KidBody):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.baseY+Obj1.zOff, Obj2.baseY+Obj2.zOff);
	}
	
	private function set_playerCandy(Value:Int):Int
	{
		if (Value < 0)
			Value = 0;
		playerCandy = Value;
		if (playerCandy == 0)
		{
			GameOver();
		}
		return playerCandy;
	}
	
	
	private function GameWin():Void
	{
		player.talking = true;
		SoundSystem.endMusic(.33);
		FlxG.camera.fade(FlxColor.BLACK, .5, false, function() {
			FlxG.switchState(new GameWinState());
		});
	}
	private function GameOver():Void
	{
		player.talking = true;
		SoundSystem.endMusic(.33);
		FlxG.camera.fade(FlxColor.BLACK, .5, false, function() {
			FlxG.switchState(new GameOverState());
		});
	}
}
