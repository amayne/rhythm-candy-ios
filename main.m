//
//  main.m
//  MusicPlayerDemo
//
//  Written by Ole Begemann, July 2009, http://oleb.net
//  Accompanying blog post: http://oleb.net/blog/2009/07/the-music-player-framework-in-the-iphone-sdk
//
//  License: do what you want with it. You are authorized to use this code in whatever way you want.
//  No need to credit me, though I'd love a backlink if you discuss this somewhere on the web.//
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
