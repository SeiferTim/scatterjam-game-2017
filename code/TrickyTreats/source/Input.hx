package;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;


class Input
{
	
	public static inline var PRESSED:Int = 0;
	public static inline var JUST_PRESSED:Int = 1;
	public static inline var JUST_RELEASED:Int = 2;
	
	public static var Left:Array<Bool>;
	public static var Right:Array<Bool>;
	public static var Up:Array<Bool>;
	public static var Down:Array<Bool>;
	
	public static var A_Button:Array<Bool>;
	public static var B_Button:Array<Bool>;
	public static var C_Button:Array<Bool>;
	
	public static var Start:Array<Bool>;
	
	public static var LEFT_KEYS:Array<FlxKey> = [LEFT, A];
	public static var RIGHT_KEYS:Array<FlxKey> = [RIGHT, D];
	public static var UP_KEYS:Array<FlxKey> = [UP, W];
	public static var DOWN_KEYS:Array<FlxKey> = [DOWN, S];
	public static var A_KEYS:Array<FlxKey> = [Z];
	public static var B_KEYS:Array<FlxKey> = [X];
	public static var C_KEYS:Array<FlxKey> = [C];
	public static var START_KEYS:Array<FlxKey> = [P];
	
	public static function update(elapsed:Float):Void
	{
		reset();
		
		Left[PRESSED] = FlxG.keys.anyPressed(LEFT_KEYS);
		Left[JUST_PRESSED] = FlxG.keys.anyJustPressed(LEFT_KEYS);
		Left[JUST_RELEASED] = FlxG.keys.anyJustReleased(LEFT_KEYS);
		
		Right[PRESSED] = FlxG.keys.anyPressed(RIGHT_KEYS);
		Right[JUST_PRESSED] = FlxG.keys.anyJustPressed(RIGHT_KEYS);
		Right[JUST_RELEASED] = FlxG.keys.anyJustReleased(RIGHT_KEYS);
		
		Up[PRESSED] = FlxG.keys.anyPressed(UP_KEYS);
		Up[JUST_PRESSED] = FlxG.keys.anyJustPressed(UP_KEYS);
		Up[JUST_RELEASED] = FlxG.keys.anyJustReleased(UP_KEYS);
		
		Down[PRESSED] = FlxG.keys.anyPressed(DOWN_KEYS);
		Down[JUST_PRESSED] = FlxG.keys.anyJustPressed(DOWN_KEYS);
		Down[JUST_RELEASED] = FlxG.keys.anyJustReleased(DOWN_KEYS);
		
		A_Button[PRESSED] = FlxG.keys.anyPressed(A_KEYS);
		A_Button[JUST_PRESSED] = FlxG.keys.anyJustPressed(A_KEYS);
		A_Button[JUST_RELEASED] = FlxG.keys.anyJustReleased(A_KEYS);
		
		B_Button[PRESSED] = FlxG.keys.anyPressed(B_KEYS);
		B_Button[JUST_PRESSED] = FlxG.keys.anyJustPressed(B_KEYS);
		B_Button[JUST_RELEASED] = FlxG.keys.anyJustReleased(B_KEYS);
		
		C_Button[PRESSED] = FlxG.keys.anyPressed(C_KEYS);
		C_Button[JUST_PRESSED] = FlxG.keys.anyJustPressed(C_KEYS);
		C_Button[JUST_RELEASED] = FlxG.keys.anyJustReleased(C_KEYS);
		
		Start[PRESSED] = FlxG.keys.anyPressed(START_KEYS);
		Start[JUST_PRESSED] = FlxG.keys.anyJustPressed(START_KEYS);
		Start[JUST_RELEASED] = FlxG.keys.anyJustReleased(START_KEYS);
		
	}
	
	public static function reset():Void
	{
		Left = [false, false, false];
		Right = [false, false, false];
		Up = [false, false, false];
		Down = [false, false, false];
		A_Button = [false, false, false];
		B_Button = [false, false, false];
		C_Button = [false, false, false];
		Start = [false, false, false];
		
	}
	
}