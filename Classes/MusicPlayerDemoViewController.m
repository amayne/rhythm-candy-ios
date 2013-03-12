//
//  MusicPlayerDemoViewController.m
//  MusicPlayerDemo
//
//  Written by Ole Begemann, July 2009, http://oleb.net
//  Accompanying blog post: http://oleb.net/blog/2009/07/the-music-player-framework-in-the-iphone-sdk
//
//  License: do what you want with it. You are authorized to use this code in whatever way you want.
//  No need to credit me, though I'd love a backlink if you discuss this somewhere on the web.//
//

#import "MusicPlayerDemoViewController.h"
#include <Accelerate/Accelerate.h>

// private interface
@interface MusicPlayerDemoViewController ()
- (void)handleNowPlayingItemChanged:(id)notification;
- (void)handlePlaybackStateChanged:(id)notification;
- (void)handleExternalVolumeChanged:(id)notification;
@end



@implementation MusicPlayerDemoViewController

@synthesize musicPlayer;
@synthesize playPauseButton;
@synthesize songLabel;
@synthesize artistLabel;
@synthesize albumLabel;
@synthesize artworkImageView;
@synthesize volumeSlider;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    // Initial sync of display with music player state
    [self handleNowPlayingItemChanged:nil];
    [self handlePlaybackStateChanged:nil];
    [self handleExternalVolumeChanged:nil];
    
    // Register for music player notifications
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self 
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                             object:self.musicPlayer];
    [notificationCenter addObserver:self 
                           selector:@selector(handlePlaybackStateChanged:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification 
                             object:self.musicPlayer];
    [notificationCenter addObserver:self 
                           selector:@selector(handleExternalVolumeChanged:)
                               name:MPMusicPlayerControllerVolumeDidChangeNotification 
                             object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Stop music player notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                                                  object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerPlaybackStateDidChangeNotification 
                                                  object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object:self.musicPlayer];
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.musicPlayer = nil;
    self.playPauseButton = nil;
    self.songLabel = nil;
    self.artistLabel = nil;
    self.albumLabel = nil;
    self.artworkImageView = nil;
    self.volumeSlider = nil;
}



- (void)dealloc {
    [musicPlayer release];
    [playPauseButton release];
    [songLabel release];
    [artistLabel release];
    [albumLabel release];
    [artworkImageView release];
    [volumeSlider release];
    [super dealloc];
}



#pragma mark Media player notification handlers

// When the now playing item changes, update song info labels and artwork display.
- (void)handleNowPlayingItemChanged:(id)notification {
    // Ask the music player for the current song.
    MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
    
    // Display the artist, album, and song name for the now-playing media item.
    // These are all UILabels.
	
    self.songLabel.text   = [[currentItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    self.artistLabel.text = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    self.albumLabel.text  = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];    
	[self.musicPlayer pause];
	[self analyseSong:currentItem];
	
    // Display album artwork. self.artworkImageView is a UIImageView.
    CGSize artworkImageViewSize = self.artworkImageView.bounds.size;
    MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.artworkImageView.image = [artwork imageWithSize:artworkImageViewSize];
    } else {
        self.artworkImageView.image = nil;
    }
}

// When the playback state changes, set the play/pause button appropriately.
- (void)handlePlaybackStateChanged:(id)notification {
    MPMusicPlaybackState playbackState = self.musicPlayer.playbackState;
    if (playbackState == MPMusicPlaybackStatePaused || playbackState == MPMusicPlaybackStateStopped) {
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

// When the volume changes, sync the volume slider
- (void)handleExternalVolumeChanged:(id)notification {
    // self.volumeSlider is a UISlider used to display music volume.
    // self.musicPlayer.volume ranges from 0.0 to 1.0.
    [self.volumeSlider setValue:self.musicPlayer.volume animated:YES];
}

#pragma mark Button actions

- (IBAction)playOrPauseMusic:(id)sender {
	MPMusicPlaybackState playbackState = self.musicPlayer.playbackState;
	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		UIWindow * window = [[self view] window];
		[[self view] setHidden:YES];
		[self initOpenGL:window];
		[self.musicPlayer play];
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[self.musicPlayer pause];
	}
}


- (IBAction)playNextSong:(id)sender {
    [self.musicPlayer skipToNextItem];
}


- (IBAction)playPreviousSong:(id)sender {
    static NSTimeInterval skipToBeginningOfSongIfElapsedTimeLongerThan = 3.5;

    NSTimeInterval playbackTime = self.musicPlayer.currentPlaybackTime;
    if (playbackTime <= skipToBeginningOfSongIfElapsedTimeLongerThan) {
        [self.musicPlayer skipToPreviousItem];
    } else {
        [self.musicPlayer skipToBeginning];
    }
}


- (IBAction)openMediaPicker:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES; // this is the default   
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}


- (IBAction)volumeSliderChanged:(id)sender {
    self.musicPlayer.volume = self.volumeSlider.value;
}



#pragma mark MPMediaPickerController delegate methods

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    // We need to dismiss the picker
    [self dismissModalViewControllerAnimated:YES];
    
    // Assign the selected item(s) to the music player and start playback.
    [self.musicPlayer stop];
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self.musicPlayer play];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    // User did not select anything
    // We need to dismiss the picker
    [self dismissModalViewControllerAnimated:YES];
}

- (void)analyseSong:(MPMediaItem *)currentItem {
	
	AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:[currentItem valueForProperty:MPMediaItemPropertyAssetURL] options:nil];
    
	NSLog([NSString stringWithFormat:@"%d", [asset duration]]);
    
	AVAssetReader* reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
    
	AVAssetTrack* track = [[asset tracks] objectAtIndex:0];
    
	AVAssetReaderTrackOutput* output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:nil];
    
	if([reader canAddOutput:output])
		NSLog(@"Can add output!");
    
	[reader addOutput:output];
    
	[reader startReading];
    
	CMSampleBufferRef sampleBuffer = NULL;
    
	AudioBufferList audioBufferList;
    
	CMBlockBufferRef blockBuffer;
    
	int numberOfBuffers = 0;
    
	int numberOfSamples = 0;
    
	int window = 1024;
    
	int windowOver2 = window/2;
    
	float totalDuration = 0;
    
	long counter = 0;
    
	float max = 0.0;
    
	float min = 0.0;
    
	float* spectrum = (float *) malloc(windowOver2 * sizeof(float));
    
	float* lastSpectrum = (float *) malloc(windowOver2 * sizeof(float));
    
	vDSP_Length log2n = 10;
    
	FFTSetup* fftSetup = vDSP_create_fftsetup (log2n, FFT_RADIX2);
    
	NSMutableArray *spectralFlux = [NSMutableArray new];
    
	BOOL first = TRUE;
    
	int leftOverSamples = 0;
    
	while((sampleBuffer = [output copyNextSampleBuffer]) != NULL) {
		numberOfBuffers++;
		CMTime duration = CMSampleBufferGetDuration(sampleBuffer);
		float durationsec = (float)duration.value/(float)duration.timescale;
		int timescale = duration.timescale;
		int durationvalue =  duration.value;
		numberOfSamples += durationvalue;
		totalDuration += durationsec;
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &audioBufferList, sizeof(audioBufferList),NULL, NULL, 0, &blockBuffer);
		AudioBuffer buffer = audioBufferList.mBuffers[1]; 
		UInt16* samples = ((UInt16*) &buffer.mData);
		float* samplesToFFT = calloc (window, sizeof (float));
		for (int i = 0; i<durationvalue; ) {
			int j=leftOverSamples;
			for (; j<window && i<durationvalue; j++) {
				samplesToFFT[j] =(samples[i++]);
			}
			if(j%window == 0){ 
				float norm = [self normalise:samplesToFFT withWindow:window];
				[self RealFFT:samplesToFFT withWindow:window withSetup:fftSetup];
				if(!first) {
					memcpy(lastSpectrum, spectrum, windowOver2); // shuffle buffers
					memcpy(spectrum, samplesToFFT, windowOver2);
					float flux = 0.0;
					float value = 0.0;
					for(int k = 0; k < windowOver2; k++){
						value = spectrum[k] - lastSpectrum[k];
						if (value >= 0.0) // rectify the signal
							flux += value;
					}
					[spectralFlux addObject:[NSNumber numberWithFloat:flux]];
				} else {
					memcpy(spectrum, samplesToFFT, windowOver2);
					first = FALSE;
				}
				leftOverSamples = 0;
			}
			else {
				// there is left over samples
				leftOverSamples = j%window;
			}
		}
		free(samplesToFFT);
	}
	float *peaks = [self findPeaks:spectralFlux];
	
	// clean up
	vDSP_destroy_fftsetup(fftSetup);
}

- (float) normalise:(float *)data withWindow:(int)N
{
	float norm = 0.0;
	
    // Get max magnitude
	
    vDSP_maxmgv(data, 1, &norm, N);
	
    // Divide by normalisation
    vDSP_vsdiv(data, 1, &norm, data, 1, N);
	
	return norm;
}

// Fast Fourier Transform, Real, In place, one dimensional

- (void) RealFFT:(float *)data withWindow:(int)N withSetup:(FFTSetup *)fftSetup
{
	
	// FFT or power to specify what the size of two.  1024 samples in this case. 
	vDSP_Length log2n = 10; 
	
	// FFT to create a setup 
	
	vDSP_Length fftSize = 1 <<log2n;
    
	DSPSplitComplex splitComplex;
    
	splitComplex.realp = calloc (fftSize, sizeof (float));
    
	splitComplex.imagp = calloc (fftSize, sizeof (float));
    
	
    /* Look at the real signal as an interleaved complex vector  by
     * casting it.  Then call the transformation function vDSP_ctoz to
     * get a split complex vector, which for a real signal, divides into
     * an even-odd configuration. */
    
    vDSP_ctoz((COMPLEX *) data, 2, &splitComplex, 1, (N/2));
    
	// FFT or inverse FFT specified.  Conversely if FFT_INVERSE 
	FFTDirection direction = FFT_FORWARD;
    
	// Specify the stride
    
	vDSP_Stride signalStride = 1;
    
	vDSP_fft_zip(fftSetup, & splitComplex, signalStride, log2n, direction);
    
	vDSP_ztoc(&splitComplex, 1, (COMPLEX *) data, 2, (N/2));
    
	free(splitComplex.realp);
    
	free(splitComplex.imagp);
}

- (float *) findPeaks:(NSMutableArray*)spectralFlux {
    
	int numberOfSampleWindows = [spectralFlux count];
    
	float *prunnedSpectralFlux = (float *) malloc(numberOfSampleWindows * sizeof(float));
    
	float *peaks = (float *) malloc(numberOfSampleWindows * sizeof(float));
    
	int THRESHOLD_WINDOW_SIZE = 10;
    
	float MULTIPLIER = 1.5;
    
	float threshold = 0.0;
    
	for(int i =0;i < numberOfSampleWindows; i++)
	{
		int start;
		if (i - THRESHOLD_WINDOW_SIZE > 0) {
			start = i - THRESHOLD_WINDOW_SIZE;
		}
		else {
			start = 0;
		}
		int end;
		//int end = Math.min( [spectralFlux count] - 1, i + THRESHOLD_WINDOW_SIZE );
		if ([spectralFlux count] - 1 < i + THRESHOLD_WINDOW_SIZE ) {
			end = [spectralFlux count] - 1;
		}
		else {
			end = i + THRESHOLD_WINDOW_SIZE;
		}
		float mean = 0.0;
		for( int j = start; j <= end; j++ ) {
            mean += [[spectralFlux objectAtIndex:j] floatValue];
		}
		mean /= (end - start);
		threshold = mean * MULTIPLIER;
		if( threshold <= [[spectralFlux objectAtIndex:i] floatValue] )
			prunnedSpectralFlux[i] = [[spectralFlux objectAtIndex:i] floatValue] - threshold;
		else
			prunnedSpectralFlux[i] = 0.0;
    }
	for( int i = 0; i < (numberOfSampleWindows - 1); i++ )
	{
		if( prunnedSpectralFlux[i] > prunnedSpectralFlux[i+1] )
			peaks[i] = prunnedSpectralFlux[i];
		else
			peaks[i] = 0.0;	
	}
    
	free(prunnedSpectralFlux);
    
	return peaks;
}
@end
