//
//  APAudioPlayer.h
//  APAudioPlayer
//
//  Created by Sergii Kryvoblotskyi on 5/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APAudioPlayerState) {
    APAudioPlayerStateStopped,
    APAudioPlayerStatePlaying,
    APAudioPlayerStatePaused,
    APAudioPlayerStateError,
    APAudioPlayerStateBuffering
};

@protocol APAudioPlayerDelegate;
@interface APAudioPlayer : NSObject

@property (nonatomic, weak) id <APAudioPlayerDelegate> delegate;
@property (assign, nonatomic, readonly) APAudioPlayerState currentState;

/**
 *  Prepares player to play item
 *
 *  @param urlPath      NSURL path of the track
 *  @param autoplay BOOL is should play immidiately
 *
 */
- (void)loadItemWithPath:(NSURL *)urlPath autoPlay:(BOOL)autoplay;

/**
 *  Prepares player to play item
 *
 *  @param url      NSURL of the track
 *  @param autoplay BOOL is should play immidiately
 *
 */
- (void)loadItemWithURL:(NSURL *)url autoPlay:(BOOL)autoplay;

/*
 Player interactions
 */
- (void)pause;
- (void)play;
- (void)stop;
- (BOOL)isPlaying;

/*
 Player values
 */
- (NSTimeInterval)duration;

/* Represents current position 0..1 */
@property (nonatomic, assign) CGFloat position;

/* Represents current volume 0..1 */
@property (nonatomic, assign) CGFloat volume;

@end

@protocol APAudioPlayerDelegate <NSObject>
@optional

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

@end