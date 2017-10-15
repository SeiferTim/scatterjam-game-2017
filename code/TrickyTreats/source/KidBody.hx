package;

import axollib.GraphicsCache;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class KidBody extends FlxSprite
{

	public inline static var MIN_DISTANCE:Float = 140;
	public inline static var MAX_SPEED:Float = 200;
	public inline static var ACC:Float = 20;
	
	public var head:FlxSprite;
	public var baseY(get, set):Float;
	public var baseX(get, set):Float;
	public var isPlayer:Bool = false;
	public var talking:Bool = false;
	public var moveAngle:Float=0;
	public var moveSpeed:Float=0;
	public var moveTimer:Float = 0;
	public var headBounceX:Float;
	public var headBounceY:Float;
	public var headTweenX:FlxTween;
	public var headTweenY:FlxTween;
	public var parent:PlayState;
	
	public var cameraFocus:FlxSprite;
	public var isMonster:Bool;
	public var tiredness(default, set):Float;
	
	public var zOff:Float;
	
	public var shadow:FlxSprite;
	
	public var bag:FlxSprite;
	
	

	public function new(Parent:PlayState, BaseX:Float, BaseY:Float, HeadNo:Int, IsPlayer:Bool = false, IsMonster:Bool = false, ZOff:Float)
	{
		super();
		
		zOff = ZOff;
		isMonster = IsMonster;
		if (isMonster)
		{
			tiredness = FlxG.random.float(0, .5);
		}
		
		
		shadow = new FlxSprite();
		var h:Float =  FlxG.random.float(0, 360);
		isPlayer = IsPlayer;
		parent = Parent;
		loadGraphic(AssetPaths.body_v2__png, false, 70, 70, true, "kid" + h);
		
		if (isPlayer)
		{
			
			shadow.loadGraphic(AssetPaths.highlight__png);
			
			
		}
		else
		{
			cameraFocus = new FlxSprite();
			cameraFocus.makeGraphic(2, 2);
			
			shadow.loadGraphic(AssetPaths.shadow__png);
		}
		
		
		
		parent.shadows.add(shadow);
		
		head = new FlxSprite();
		
		
		head.frames = GraphicsCache.loadGraphicFromAtlas("masks", AssetPaths.masks__png, AssetPaths.masks__xml).atlasFrames;
		head.animation.frameIndex = HeadNo;
		head.centerOffsets();
		head.centerOrigin();
		
		
		bag = new FlxSprite();
		bag.frames = GraphicsCache.loadGraphicFromAtlas("bags", AssetPaths.bags__png, AssetPaths.bags__xml).atlasFrames;
		bag.animation.randomFrame();
		bag.centerOffsets();
		bag.centerOrigin();
		
		baseX = BaseX;
		baseY = BaseY;
		
		headTweenY = FlxTween.num(0, -6, .2, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, updateHeadBounceY);
		headTweenX = FlxTween.num(-3, 3, .4, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, updateHeadBounceX);

	}
	
	private function set_tiredness(Value:Float):Float
	{
		if (Value > 1)
			Value = 1;
		else if (Value < 0)
			Value = 0;
		tiredness = Value;
		return tiredness;
	}
	
	private function updateHeadBounceX(Value:Float):Void
	{
		headBounceX = Value;
	}
	
	private function updateHeadBounceY(Value:Float):Void
	{
		headBounceY = Value;
	}
	
	private function updateHeadPos():Void
	{
		head.y = y - 100 - headBounceY;
		head.x = x + (width / 2) - (head.width / 2) - headBounceX;
		if (cameraFocus != null)
		{
			cameraFocus.x = baseX + 100;
			cameraFocus.y = y - 20;
		}
		shadow.x = baseX -(shadow.width / 2);
		shadow.y = baseY - (shadow.height / 2);
		bag.x = baseX + 12;
		bag.y = baseY - 42 - (headBounceY * .2);
	}
	
	private function set_baseY(Value:Float):Float
	{
		//baseY = Value;
		y = Value - height;
		updateHeadPos();
		return baseY;
	}
	
	private function set_baseX(Value:Float):Float
	{
		//baseX = Value;
		x = Value - (width / 2);
		updateHeadPos();
		return baseX;
	}
	
	private function get_baseY():Float
	{
		return y + height;
	}
	
	private function get_baseX():Float 
	{
		return x + (width / 2);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!isPlayer)
		{
			// random movement unless being talked too...
			if (talking)
			{
				velocity.set();
				moveTimer = 0;
			}
			else
			{
				if (moveTimer <= 0)
				{
					moveTimer = FlxG.random.int(1, 5) * .33;
					moveSpeed = FlxG.random.weightedPick([70, 20, 10]) * 50;
					moveAngle = FlxG.random.float(0, 259);
					velocity.set(moveSpeed, 0).rotate(FlxPoint.weak(), moveAngle);
					
					
				}
				else
				{
					moveTimer -= elapsed;
				}
				
				moveAway();
			}
		}
		else
		{
			PlayerMovement();
		}
		
		if (x + width > FlxG.worldBounds.x + FlxG.worldBounds.width)
			x = FlxG.worldBounds.x + FlxG.worldBounds.width - width;
		else if (x < FlxG.worldBounds.x)
			x = FlxG.worldBounds.x;
		if (baseY > FlxG.worldBounds.y + FlxG.worldBounds.height)
			baseY = FlxG.worldBounds.y + FlxG.worldBounds.height;
		else if (baseY < FlxG.worldBounds.y)
			baseY = FlxG.worldBounds.y;
		
		
		
		
		
		super.update(elapsed);
		
		
	}
	
	override public function draw():Void 
	{
		
		updateHeadPos();
		super.draw();
	}
	
	private function moveAway():Void
	{
		var d:Float;
		var move:FlxPoint = FlxPoint.get();
		var k:KidBody;
		for (i in parent.kids.members)
		{
			if (Type.getClass(i) == KidBody)
			{
				k = cast i;
				if (k != this && !k.isPlayer)
				{
					d = FlxMath.distanceBetween(this, k);
					if (d < MIN_DISTANCE)
					{
						var a:Float = FlxAngle.angleBetween(k, this, true);
						var v:FlxPoint = FlxVelocity.velocityFromAngle( a, 5 * (1 - (d / MIN_DISTANCE)));
						move.x += v.x;
						move.y += v.y;
						
					}
				}
			}
		}
		velocity.x += move.x;
		velocity.y += move.y;
	}
	
	private function PlayerMovement():Void
	{
		if (!talking)
		{
			var left:Bool = Input.Left[Input.PRESSED];
			var right:Bool = Input.Right[Input.PRESSED];
			var up:Bool = Input.Up[Input.PRESSED];
			var down:Bool = Input.Down[Input.PRESSED];
			
			if (left && right)
				left = right = false;
			if (up && down)
				up = down = false;
			
			if (up || down || left || right)
			{
				var newAngle:Float = Math.NEGATIVE_INFINITY;
				if (up && left)
				{
					newAngle = -135;
				}
				else if (up && right)
				{
					newAngle = -45;
				}
				else if (up)
				{
					newAngle = -90;
				}
				else if (down && left)
				{
					newAngle = 135;
				}
				else if (down && right)
				{
					newAngle = 45;
				}
				else if (down)
				{
					newAngle = 90;
				}
				else if (left)
				{
					newAngle = 180;
				}
				else if (right)
				{
					newAngle = 0;
				}
				
				if (moveAngle != newAngle)
				{
					//moveSpeed = ACC;
					moveAngle = newAngle;
				}
				else
				{
					moveSpeed += ACC;
					if (moveSpeed > MAX_SPEED)
						moveSpeed = MAX_SPEED;
				}
				
			}
			else
			{
				moveSpeed -= ACC;
				if (moveSpeed < 0)
					moveSpeed  = 0;
			}
			
			//trace(moveSpeed, moveAngle);
			
			velocity = FlxVelocity.velocityFromAngle(moveAngle, moveSpeed);
		}
		else
		{
			moveSpeed = 0;
			velocity.set();
		}
	}
	
	override public function kill():Void 
	{
		
		headTweenX.destroy();
		headTweenY.destroy();
		head.kill();
		shadow.kill();
		bag.kill();
		if (cameraFocus != null)
			cameraFocus.kill();
		
		
		
		super.kill();
	}
	
	override public function destroy():Void 
	{
		head = FlxDestroyUtil.destroy(head);
		shadow = FlxDestroyUtil.destroy(shadow);
		bag = FlxDestroyUtil.destroy(bag);
		if (cameraFocus != null)
			cameraFocus = FlxDestroyUtil.destroy(cameraFocus);
		
		super.destroy();
	}
	

}