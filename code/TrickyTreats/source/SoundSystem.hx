package;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import openfl.Assets;
import openfl.media.Sound;

class SoundSystem {
	
	
	public static var groupSound:FlxSoundGroup;
	public static var groupMusic:FlxSoundGroup;
	
	public static var volumeSound(get, set):Float;
	public static var volumeMusic(get, set):Float;
	
	public static var currentMusic:Null<FlxSoundAsset>;
	public static var music:FlxSound;
	
	public static var soundSave:FlxSave;
	
	public static var initialized:Bool = false;
	
	static public function initSound():Void
	{
		if (initialized)
			return;
		initialized = true;
		
		
		soundSave = new FlxSave();
		soundSave.bind("monstermasks-sound-save");
		if (soundSave.data.volSound == null)
			soundSave.data.volSound = 1;
		if (soundSave.data.volMusic == null)
			soundSave.data.volMusic = 1;
		soundSave.flush();
		
		groupSound = new FlxSoundGroup(soundSave.data.volSound);
		groupMusic = new FlxSoundGroup(soundSave.data.volMusic);
		
		FlxG.sound.defaultMusicGroup = groupMusic;
		FlxG.sound.defaultSoundGroup = groupSound;
	}
	
	static public function playMusic(Music:FlxSoundAsset, ?FadeInTime:Float=-1, ?LoopTrack:Null<FlxSoundAsset>):Void
	{
		if ((currentMusic != Music && (LoopTrack != null || LoopTrack != currentMusic)) || currentMusic == null)
		{
			if (music != null)
			{
				if (music.exists)
				{
					music.fadeOut(.1, 0, function(_) {
						switchToMusic(Music, FadeInTime, LoopTrack);
					});
				}
				else
				{
					switchToMusic(Music, FadeInTime, LoopTrack);
				}
			}
			else
			{
				switchToMusic(Music, FadeInTime, LoopTrack);
			}
		}
	}
	
	static private function switchToMusic(Music:FlxSoundAsset, ?FadeInTime:Float =-1, ?LoopTrack:Null<FlxSoundAsset>):Void
	{
		if (LoopTrack != null)
		{
			music = FlxG.sound.play(Music, 1, false, groupMusic, true, function() {
				if (currentMusic == Music)
				{
					switchToMusic(LoopTrack, -1, null);
				}
			});
			currentMusic = Music;
		}
		else
		{
			music = FlxG.sound.play(Music, 1, true, groupMusic, false);
			if (FadeInTime != -1)
			{
				music.fadeIn(FadeInTime, 0.00000001,1);
			}
			currentMusic = Music;
		}
	}
	
	static private function set_volumeSound(Amount:Float):Float
	{
		groupSound.volume = FlxMath.bound(Amount, 0,1);
		
		soundSave.data.volSound = groupSound.volume;
		soundSave.flush();
		
		return groupSound.volume;
		
	}
	
	static private function set_volumeMusic(Amount:Float):Float
	{
		groupMusic.volume = FlxMath.bound(Amount, 0,1);
		
		if (music != null)
		{
			if (music.exists && music.playing)
			{
				music.volume = groupMusic.volume;
			}
		}
		
		soundSave.data.volMusic = groupMusic.volume;
		soundSave.flush();
		
		return groupMusic.volume;
	}
	
	static private function get_volumeSound():Float
	{
		return groupSound.volume;
	}
	
	static private function get_volumeMusic():Float
	{
		return groupMusic.volume;
	}
	
	static public function endMusic(FadeTime:Float = 1):Void
	{
		if (music != null)
		{
			if (music.exists && music.playing)
			{
				music.fadeOut(FadeTime, 0, function(_) {
					music = FlxDestroyUtil.destroy(music);
					currentMusic = null;
				});
			}
		}
	}
	
	static public function fadeMusic(FadeTime:Float, FadeAmount:Float):Void
	{
		if (music != null)
		{
			if (music.exists && music.playing)
			{
				if (music.volume >= FadeAmount)
				{
					music.fadeOut(FadeTime, FadeAmount);
				}
				else
				{
					music.fadeIn(FadeTime, FadeAmount);
				}
			}
		}
	}
	
}