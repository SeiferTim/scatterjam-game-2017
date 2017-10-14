package;

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

class KidBody extends FlxSprite
{

	public inline static var MIN_DISTANCE:Float = 140;
	
	public var head:FlxSprite;
	public var baseY(get, set):Float;
	public var baseX(get, set):Float;
	public var isPlayer:Bool = false;
	public var talking:Bool = false;
	public var moveAngle:Float;
	public var moveSpeed:Float;
	public var moveTimer:Float = 0;
	public var headBounceX:Float;
	public var headBounceY:Float;
	public var headTweenX:FlxTween;
	public var headTweenY:FlxTween;
	public var parent:PlayState;
	

	public function new(Parent:PlayState, BaseX:Float, BaseY:Float)
	{
		super();
		
		
		parent = Parent;
		makeGraphic(70, 70, FlxColor.BLUE);
		head = new FlxSprite();
		head.makeGraphic(150, 200, FlxColor.WHITE);
		head.alpha = .5;
		
		baseX = BaseX;
		baseY = BaseY;
		
		headTweenY = FlxTween.num(0, 12, .2, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, updateHeadBounceY);
		headTweenX = FlxTween.num(-12, 12, .4, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut}, updateHeadBounceX);

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
		head.y = y - 140 - headBounceY;
		head.x = x + (width / 2) - (head.width / 2) - headBounceX;
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
		
		if (x + width > FlxG.worldBounds.x + FlxG.worldBounds.width)
			x = FlxG.worldBounds.x + FlxG.worldBounds.width - width;
		else if (x < FlxG.worldBounds.x)
			x = FlxG.worldBounds.x;
		if (baseY > FlxG.worldBounds.y + FlxG.worldBounds.height)
			baseY = FlxG.worldBounds.y + FlxG.worldBounds.height;
		else if (baseY < FlxG.worldBounds.y)
			baseY = FlxG.worldBounds.y;
		
		
		updateHeadPos();
		
		
		super.update(elapsed);
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
				if (k != this)
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
	

}