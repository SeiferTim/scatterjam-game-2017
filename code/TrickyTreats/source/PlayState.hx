package;

import flash.net.SharedObject;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxPieDial;
import flixel.addons.display.FlxPieDial.FlxPieDialShape;
import flixel.addons.display.FlxZoomCamera;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import openfl.Assets;


class PlayState extends FlxState
{
	
	public static inline var MAX_MASKS:Int = 29;
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
	public var monstCounter:FlxBitmapText;
	
	public var playerCandy(default, set):Int = 10;
	
	public var hudCam:FlxCamera;
	public var mainCam:FlxCamera;
	
	public var music:FlxSound;
	public var monstersCaught:Int = 0;
	
	public var bgGrad:FlxSprite;
	public var bgStars:FlxSprite;
	public var bgMoon:FlxSprite;
	public var bgClouds:FlxGroup;
	
	public var candyIcon:FlxSprite;
	
	public var explosions:FlxTypedGroup<Explosion>;
	public var punches:FlxTypedGroup<Punch>;
	
	public var timer:FlxPieDial;
	
	public var sndMonsterDeaths:Array<FlxSoundAsset>;
	public var sndInteract:Array<FlxSoundAsset>;
	public var sndGiveCandy:Array<FlxSoundAsset>;
	public var sndWrong:Array<FlxSoundAsset>;
	public var sndTimeUp:Array<FlxSoundAsset>;
	
	override public function create():Void
	{
		super.create();
		
		
		sndMonsterDeaths = [AssetPaths.ahhwwww__wav, AssetPaths.arrrgg__wav];
		sndInteract = [AssetPaths.hey__wav];
		sndGiveCandy = [AssetPaths.munch__wav, AssetPaths.nomnom1__wav];
		sndWrong = [AssetPaths.Oh__wav, AssetPaths.Watch_it__wav];
		sndTimeUp = [AssetPaths.Time_for_bed__wav];
		
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
		
		
		bgGrad = FlxGradient.createGradientFlxSprite(1600, 2700, [0xffFB9553, 0xffDB4648, 0xff9f3647, 0xff5D2747, 0xff3F264D, 0xff3F264D], 1, -90);
		bgGrad.scrollFactor.set();
		bgGrad.x = 0;
		bgGrad.y = -2400;
		add(bgGrad);
		
		bgStars = new FlxSprite(0, 0, AssetPaths.star_field__png);
		bgStars.screenCenter(FlxAxes.X);
		bgStars.scrollFactor.set();
		bgStars.alpha = 0;
		add(bgStars);
		
		bgMoon = new FlxSprite(0, 0, AssetPaths.moon__png);
		bgMoon.scrollFactor.set();
		bgMoon.x = bgMoon.width * 2;
		bgMoon.y = bgMoon.height * 3;
		add(bgMoon);
		
		bgClouds = new FlxGroup();
		add(bgClouds);
		
		for (i in 0...20)
			bgClouds.add(new Cloud());
		
		
		var bg:FlxSprite = new FlxSprite(0, 0, AssetPaths.tree_layer_2__png);
		bg.screenCenter(FlxAxes.X);
		bg.scrollFactor.set(.5, .5);
		add(bg);
		
		bg = new FlxSprite(0, 0, AssetPaths.tree_layer_1__png);
		bg.screenCenter(FlxAxes.X);
		bg.scrollFactor.set(.8, .8);
		add(bg);
		
		bg = new FlxSprite(0, 0, AssetPaths.houses_foreground__png);
		bg.screenCenter(FlxAxes.X);
		bg.y = FlxG.height - bg.height + 40;
		add(bg);
		
		
		
		FlxG.camera.setScrollBounds( -40, FlxG.width + 40, -40, FlxG.height +40);
		FlxG.camera.style  = FlxCameraFollowStyle.TOPDOWN;
		FlxG.worldBounds.set( 200, (FlxG.height / 2) + 50, FlxG.width - 400, (FlxG.height / 2) - 30);
		
		
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
			kids.add(k.bag);
			
		}
		
		for (i in 0...MONST_COUNT)
		{
			k = new KidBody(this,  FlxG.random.float(120, FlxG.width - 120), FlxG.random.float(FlxG.height / 2, FlxG.height - 120), masks[i + KID_COUNT], false, true, .001 * (i+KID_COUNT));
			trace(k.head.animation.frameName);
			kids.add(k);
			kids.add(k.head);
			kids.add(k.bag);
			
		}
		
		player = new KidBody(this, FlxG.random.float(120, FlxG.width - 120), FlxG.random.float(FlxG.height / 2, FlxG.height - 120), masks[KID_COUNT+MONST_COUNT], true,false,  .001 * (KID_COUNT+MONST_COUNT));
		kids.add(player);
		kids.add(player.head);
		kids.add(player.bag);
		
		FlxG.camera.target = player;
		
		target = new FlxSprite();
		target.loadGraphic(AssetPaths.target__png);
		target.visible = false;
		add(target);
		
		dialog = new Dialog(this);
		add(dialog);
		
		explosions = new FlxTypedGroup<Explosion>();
		add(explosions);
		
		punches = new FlxTypedGroup<Punch>();
		add(punches);
		
		
		candyIcon = new FlxSprite(0, 0, AssetPaths.candybar__png);
		candyIcon.scrollFactor.set();
		candyIcon.camera = hudCam;
		candyIcon.cameras = [hudCam];
		add(candyIcon);
		
		
		candyCounter = new FlxBitmapText(font_light);
		candyCounter.text = "10";
		candyCounter.scrollFactor.set();
		candyCounter.color = FlxColor.ORANGE;
		candyCounter.alignment = "center";
		candyCounter.x = 64;
		candyCounter.y = FlxG.height - candyCounter.height - 24;
		candyCounter.camera = hudCam;
		candyCounter.cameras = [hudCam];
		candyIcon.x = candyCounter.x + (candyCounter.width / 2) - (candyIcon.width / 2);
		candyIcon.y = candyCounter.y + (candyCounter.height / 2) - (candyIcon.height / 2);
		
		
		add(candyCounter);
		
		
		monstCounter = new FlxBitmapText(font_light);
		monstCounter.text = Std.string(MONST_COUNT);
		monstCounter.scrollFactor.set();
		monstCounter.color = FlxColor.PURPLE;
		monstCounter.alignment = "center";
		monstCounter.x = FlxG.width - monstCounter.width - 64;
		monstCounter.y = FlxG.height - monstCounter.height - 24;
		monstCounter.camera = hudCam;
		monstCounter.cameras = [hudCam];
		
		var monsIcon:FlxSprite = new FlxSprite(0, 0, AssetPaths.monsters_left_icon__png);
		monsIcon.scrollFactor.set();
		monsIcon.x = monstCounter.x + (monstCounter.width / 2) - (monsIcon.width / 2);
		monsIcon.y = monstCounter.y + (monstCounter.height / 2) - (monsIcon.height / 2)-20;
		monsIcon.camera = hudCam;
		monsIcon.cameras = [hudCam];
		
		add(monsIcon);
		
		add(monstCounter);
		
		
		timer = new FlxPieDial(0, 0, 60, FlxColor.ORANGE, 180, FlxPieDialShape.CIRCLE, true, 0);
		timer.x = FlxG.width - timer.width - 64;
		timer.y = 64;
		timer.amount = 1;
		timer.scrollFactor.set();
		timer.camera = hudCam;
		timer.cameras = [hudCam];
		
		var clock:FlxSprite = new FlxSprite(0, 0, AssetPaths.clock__png);
		clock.scrollFactor.set();
		clock.x = timer.x - 20;
		clock.y = timer.y - 20;
		clock.camera = hudCam;
		clock.cameras = [hudCam];
		add(clock);
		add(timer);
		
		
		FlxTween.tween(bgGrad, {y:0}, 180, {type:FlxTween.ONESHOT, ease:FlxEase.linear});
		FlxTween.tween(timer, {amount:0}, 180, {type:FlxTween.ONESHOT, ease:FlxEase.linear, onComplete:timeUp});
		FlxTween.tween(bgStars, {alpha:1, y: -300}, 130, {type: FlxTween.ONESHOT, ease:FlxEase.linear, startDelay: 50 });
		FlxTween.circularMotion(bgMoon, FlxG.width * .2, FlxG.height * .33, (FlxG.height * .45)-bgMoon.height, 180, true, 500, true );
		
		SoundSystem.playMusic(AssetPaths.Halloween_Fun__mp3, -1, AssetPaths.Halloween_Fun__mp3);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
	}
	
	private function timeUp(_):Void
	{
		FlxG.sound.play(FlxG.random.getObject(sndTimeUp), 1, false, null, true, function() {
			GameOver();
		});
		
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
	
	public function spawnExplosion(X:Float, Y:Float):Void
	{
		var e:Explosion = explosions.recycle(Explosion, null, true, false);
		if (e == null)
		{
			e = new Explosion();
		}
		e.spawn(X, Y);
		explosions.add(e);
	}
	
	public function spawnPunch(X:Float, Y:Float):Void
	{
		var p:Punch = punches.recycle(Punch, null, true, false);
		if (p == null)
		{
			p = new Punch();
		}
		p.spawn(X, Y);
		punches.add(p);
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
					FlxG.sound.play(FlxG.random.getObject(sndGiveCandy));
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
		FlxG.sound.play(FlxG.random.getObject(sndInteract));
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
				FlxG.sound.play(FlxG.random.getObject(sndMonsterDeaths));
				spawnExplosion(targeting.baseX, targeting.baseY);
				targeting.kill();
				playerCandy += 10;
				candyCounter.text = Std.string(playerCandy);
				targeting = null;
				player.talking = false;
				monstersCaught++;
				monstCounter.text = Std.string(MONST_COUNT - monstersCaught);
				if (monstersCaught >= MONST_COUNT)
					GameWin();
				
			}
			else
			{
				FlxG.sound.play(FlxG.random.getObject(sndWrong));
				spawnPunch(player.baseX, player.baseY);
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
			kids.members.push(kidsArr[i].bag);
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
