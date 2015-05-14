//
//  APAudioPlayer.m
//  APAudioPlayer
//
//  Created by Sergii Kryvoblotskyi on 5/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "APAudioPlayer.h"
#import "bass.h"
#import <AVFoundation/AVFoundation.h>

@interface APAudioPlayer () <AVAudioSessionDelegate> {
	HSTREAM _channel;
}


- (void)_notifyStatusChanged;
- (void)_notifyDidFinishPlaying;
- (void)_notifyBeginInterruption;
- (void)_notifyEndInterruptionShouldResume:(BOOL)should;

@end

// the sync callback
void CALLBACK ChannelEndedCallback(HSYNC handle, DWORD channel, DWORD data, void *user)
{
    APAudioPlayer *player = (__bridge APAudioPlayer *)(user);
    
    //notify delegate
    [player _notifyStatusChanged];
    [player _notifyDidFinishPlaying];
}

@implementation APAudioPlayer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        //Load flac
        extern void BASSFLACplugin, BASSWVplugin, BASSOPUSplugin;
        BASS_PluginLoad(&BASSFLACplugin, 0);
        BASS_PluginLoad(&BASSWVplugin, 0);
        BASS_PluginLoad(&BASSOPUSplugin, 0);
        
        //BASS init
        BASS_Init(-1, 44100, 0, NULL, NULL);

        //Observe interuptions
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioInteruptionOccured:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        //Set volume
        _volume = BASS_GetConfig(BASS_CONFIG_GVOL_STREAM) / 10000.0f;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    BASS_Free();
}

#pragma mark -
#pragma mark - Public API
#pragma mark -

#pragma mark - Controls

- (BOOL)loadItemWithURL:(NSURL *)url autoPlay:(BOOL)autoplay
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //Stop channel;
    BASS_ChannelStop(_channel);
    
    //Free memory
    BASS_StreamFree(_channel);
    
    _channel = BASS_StreamCreateFile(FALSE, [[url path] cStringUsingEncoding:NSUTF8StringEncoding], 0, 0, 0);
    
    //Set callback
    BASS_ChannelSetSync(_channel, BASS_SYNC_END, 0, ChannelEndedCallback, (__bridge void *)self);
    
    /* Play if needed */
    if (autoplay) {
        [self play];
    }

    int code = BASS_ErrorGetCode();
    return code == 0;
}

- (void)pause
{
    BASS_ChannelPause(_channel);
    
    [self _notifyStatusChanged];
}

- (void)play
{
    BASS_ChannelPlay(_channel, NO);
    
    [self _notifyStatusChanged];
}

- (void)stop
{
    BASS_ChannelStop(_channel);
    
    [self _notifyStatusChanged];
}

- (BOOL)isPlaying
{
    DWORD isPlaying = BASS_ChannelIsActive(_channel);
    return isPlaying == BASS_ACTIVE_PLAYING;
}

#pragma mark - Values

- (NSTimeInterval)duration
{
    QWORD len = BASS_ChannelGetLength(_channel, BASS_POS_BYTE);
    double time = BASS_ChannelBytes2Seconds(_channel, len);
    return time;
}

- (NSTimeInterval)position
{
    QWORD len = BASS_ChannelGetPosition(_channel, BASS_POS_BYTE);
    double position = BASS_ChannelBytes2Seconds(_channel, len);
    return position;
}

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    BASS_SetConfig(BASS_CONFIG_GVOL_STREAM, volume * 10000.0);
}

#pragma mark - AudioSessionDelegate

- (void)audioInteruptionOccured:(NSNotification *)notification
{
    NSDictionary *interruptionDictionary = [notification userInfo];
    AVAudioSessionInterruptionType interruptionType = [interruptionDictionary[AVAudioSessionInterruptionTypeKey] integerValue];
    
    switch (interruptionType) {
        case AVAudioSessionInterruptionTypeBegan: {
            
            [self _notifyBeginInterruption];
        }
            
            break;
        case AVAudioSessionInterruptionTypeEnded: {
            AVAudioSessionInterruptionOptions options = [interruptionDictionary[AVAudioSessionInterruptionOptionKey] integerValue];
            
            [self _notifyEndInterruptionShouldResume:options == AVAudioSessionInterruptionOptionShouldResume];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private

- (void)_notifyStatusChanged
{
    if ([self.delegate respondsToSelector:@selector(playerDidChangePlayingStatus:)]) {
        [self.delegate playerDidChangePlayingStatus:self];
    }
}

- (void)_notifyDidFinishPlaying
{
    if ([self.delegate respondsToSelector:@selector(playerDidFinishPlaying:)]) {
        [self.delegate playerDidFinishPlaying:self];
    }
}

- (void)_notifyBeginInterruption
{
    if ([self.delegate respondsToSelector:@selector(playerBeginInterruption:)]) {
        [self.delegate playerBeginInterruption:self];
    }
}

- (void)_notifyEndInterruptionShouldResume:(BOOL)should
{
    if ([self.delegate respondsToSelector:@selector(playerEndInterruption:shouldResume:)]) {
        [self.delegate playerEndInterruption:self shouldResume:should];
    }
}

@end
