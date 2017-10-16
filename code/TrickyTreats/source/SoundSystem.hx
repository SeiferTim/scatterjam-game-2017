package;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.Assets;
import openfl.media.Sound;

class SoundSystem {
	
	
	
	public static var volumeMusic(default, set):Float = .5;
	
	
	public static var currentMusic:Null<FlxSoundAsset>;
	
	
	
	static public function playMusic(Music:FlxSoundAsset, ?FadeInTime:Float=-1, ?LoopTrack:Null<FlxSoundAsset>):Void
	{
		if ((currentMusic != Music && (LoopTrack != null || LoopTrack != currentMusic)) || currentMusic == null)
		{
			
			if (FlxG.sound.music != null)
			{
				if (FlxG.sound.music.exists)
				{
					FlxG.sound.music.fadeOut(.1, 0, function(_) {
						switchToMusic(Music, FadeInTime, LoopTrack);
					});
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
			FlxG.sound.play(Music, volumeMusic, false, null, true, function() {
				if (currentMusic == Music)
				{
					switchToMusic(LoopTrack, -1, null);
				}
			});
			currentMusic = Music;
		}
		else
		{
			FlxG.sound.playMusic(Music, volumeMusic, true);
			if (FadeInTime != -1)
			{
				FlxG.sound.music.fadeIn(FadeInTime, 0.00000001, volumeMusic);
			}
			currentMusic = Music;
		}
	}
	
	static public function set_volumeMusic(Amount:Float):Float
	{
		volumeMusic = FlxMath.bound(Amount, 0,1);
		
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.exists  && FlxG.sound.music.playing)
			{
				FlxG.sound.music.volume = volumeMusic;
			}
		}
		
		//Save.data.volMusic = volumeMusic;
		return volumeMusic;
	}
	
	static public function endMusic(FadeTime:Float = 1):Void
	{
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.exists && FlxG.sound.music.playing)
			{
				FlxG.sound.music.fadeOut(FadeTime, 0, function(_) {
					currentMusic = null;
				});
			}
		}
	}
	
}