//
//  MusicPlayerDemoViewController.h
//  MusicPlayerDemo
//
//  Written by Ole Begemann, July 2009, http://oleb.net
//  Accompanying blog post: http://oleb.net/blog/2009/07/the-music-player-framework-in-the-iphone-sdk
//
//  License: do what you want with it. You are authorized to use this code in whatever way you want.
//  No need to credit me, though I'd love a backlink if you discuss this somewhere on the web.//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>


@interface MusicPlayerDemoViewController : UIViewController <MPMediaPickerControllerDelegate> {
    MPMusicPlayerController *musicPlayer;
    
    UIButton *playPauseButton;
    UILabel *songLabel;
    UILabel *artistLabel;
    UILabel *albumLabel;
    UIImageView *artworkImageView;
    UISlider *volumeSlider;
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UILabel *songLabel;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *albumLabel;
@property (nonatomic, retain) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;

- (void)initOpenGL:(UIWindow*)window;
- (IBAction)playOrPauseMusic:(id)sender;
- (IBAction)playNextSong:(id)sender;
- (IBAction)playPreviousSong:(id)sender;
- (IBAction)openMediaPicker:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;
- (float)normalise:(float *)data withWindow:(int)N;
- (void)RealFFT:(float *)data withWindow:(int)N withSetup:(FFTSetup *)fftSetup;

@end

