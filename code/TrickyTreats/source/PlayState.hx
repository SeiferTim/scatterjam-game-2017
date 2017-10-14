package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	
	public var kids:FlxGroup;
	
	override public function create():Void
	{
		super.create();
		
		
		 
		FlxG.worldBounds.set( 70, FlxG.height / 2, FlxG.width - 140, (FlxG.height / 2) - 70);
		
		kids = new FlxGroup();
		add(kids);
		
		var k:KidBody;
		
		for (i in 0...12)
		{
			k = new KidBody(this,  FlxG.random.float(70, FlxG.width - 70), FlxG.random.float(FlxG.height / 2, FlxG.height - 70));
			kids.add(k);
			kids.add(k.head);
			
		}
		
		
		
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		sortKids();
		
		
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
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.baseY, Obj2.baseY);
	}
	
}
