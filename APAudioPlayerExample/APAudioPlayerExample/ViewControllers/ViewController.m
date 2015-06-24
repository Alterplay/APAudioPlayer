//
//  ViewController.m
//  APAudioPlayerExample
//
//  Created by Sergii Kryvoblotskyi on 5/14/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ViewController.h"
#import <APAudioPlayer/APAudioPlayer.h>

static NSString *const kFileToTestNameInTheBundle = @"14 - rape me (nirvana cover).mp3";

@interface ViewController () <APAudioPlayerDelegate>

/* Player */
@property (nonatomic, strong) APAudioPlayer *player;

/* UI */
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;

@property (weak, nonatomic) IBOutlet UISlider *volumeSliderView;
@property (weak, nonatomic) IBOutlet UISlider *progressSliderView;

@property (weak, nonatomic) IBOutlet UIButton *togglePlayButton;

/* Timer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (APAudioPlayer *)player
{
    if (!_player) {
        _player = [APAudioPlayer new];
        _player.delegate = self;
    }
    return _player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:kFileToTestNameInTheBundle withExtension:nil];
    [self.player loadItemWithURL:url autoPlay:NO];
    self.fileNameLabel.text = url.lastPathComponent;
    self.volumeSliderView.value = self.player.volume;
}

- (void)dealloc
{
    [self unshceduleProgressTimer];
    [self.player stop];
}

#pragma mark - Appearance

- (void)updateTrackProgressView:(NSTimer *)timer
{
    self.progressSliderView.value = self.player.position;
}

- (void)updateTogglePlayButton
{
    if (self.player.isPlaying) {
        [self.togglePlayButton setTitle:@"[Pause]" forState:UIControlStateNormal];
    } else {
        [self.togglePlayButton setTitle:@"[Play]" forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (IBAction)togglePlayButtonClicked:(id)sender
{
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (IBAction)volumeSliderValueChanged:(UISlider *)slider
{
    self.player.volume = slider.value;
}

- (IBAction)positionSliderValueChanged:(UISlider *)sender
{
    self.player.position = sender.value;
}

#pragma mark - APAudioPlayerDelegate

- (void)playerDidChangePlayingStatus:(APAudioPlayer *)player
{
    if (player.isPlaying) {
        [self scheduleProgressTimer];
    } else {
        [self unshceduleProgressTimer];
    }
    [self updateTogglePlayButton];
}

- (void)playerDidFinishPlaying:(APAudioPlayer *)player
{
    [self unshceduleProgressTimer];
    [self updateTogglePlayButton];
}

#pragma mark - Timer

- (void)scheduleProgressTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTrackProgressView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)unshceduleProgressTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
