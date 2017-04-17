# APAudioPlayer

<img src="https://dl.dropboxusercontent.com/u/2334198/APAudioPlayer-git-teaser.png">

Drop-in iOS Audio Player built on top of BASS-library. 

### Supported formats:

*.m4a,
*.mp3,
*.mp2, 
*.mp1,
*.wave,
*.ogg,
*.wav, 
*.aiff,
*.opus,
*.flac,
*.wv.
... and even more I haven't tested.

### Dead-simple interface:


Play:

```objc
- (BOOL)playItemWithURL:(NSURL *)url;
```

Pause:

```objc
- (void)pause;
```

Resume:

```objc
- (void)resume;
```

Is playing?:

```objc
- (BOOL)isPlaying;
```

Get current track duration:

```objc
- (NSTimeInterval)duration;
```

Get and set current track position:

```objc
/* Represents current position 0..1 */
@property (nonatomic, assign) CGFloat position;
```

Get and set volume:

```objc
//0..1
@property (nonatomic, assign) CGFloat volume;
```

### Dead-simple protocol:

```objc
/**
 *  Notifies the delegate about playing status changed
 *
 *  @param player APAudioPlayer
 */
- (void)playerDidChangePlayingStatus:(APAudioPlayer *)player;

/**
 *  Will be called when track is over
 *
 *  @param player APAudioPlayer
 */
- (void)playerDidFinishPlaying:(APAudioPlayer *)player;

/**
 *   Will be called when interruption occured. For ex. phone call. Basically you should call - (void)pause in this case.
 *
 *  @param player APAudioPlayer
 */
- (void)playerBeginInterruption:(APAudioPlayer *)player;

/**
 *   Will be called when interruption ended. For ex. phone call ended. It's up to you to decide to call - (void)resume or not.
 *
 *  @param player APAudioPlayer
 *  @param should BOOL
 */
- (void)playerEndInterruption:(APAudioPlayer *)player shouldResume:(BOOL)should;

```


### Integration:

CocoaPods:
```ruby
pod 'APAudioPlayer'
```

Manually:

1. Drag-and-drop APAudioPlaeyr folder into your project.
2. Add AVFoundation.framework to your project
3. Instantiate APAudioPlayer and have fun:

```objc
//Somewhere during init
self.player = [APAudioPlayer new];

//Somewhere else
NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Meat Loaf - Dead Ringer" withExtension:@"wv"];
[self.player playItemWithURL:fileURL];
```

### Example:

Checkout [Example](https://github.com/Alterplay/APAudioPlayer/tree/master/APAudioPlayerExample) folder.

![Screenshot](/screenshots/scr1.png)

### BASS:

BASS is an audio library for use in software on several platforms. Its purpose is to provide developers with powerful and efficient sample, stream (MP3, MP2, MP1, OGG, WAV, AIFF, custom generated, and more via OS codecs and add-ons), MOD music (XM, IT, S3M, MOD, MTM, UMX), MO3 music (MP3/OGG compressed MODs), and recording functions. All in a compact DLL that won't bloat your distribution.

http://www.un4seen.com

http://www.un4seen.com/bass.html#license

### What's next?:

1. Online streaming.

#### Contacts

If you have improvements or concerns, feel free to post [an issue](https://github.com/Alterplay/APAudioPlayer/issues) and write details.

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APAddressBook) with other ideas and projects.
