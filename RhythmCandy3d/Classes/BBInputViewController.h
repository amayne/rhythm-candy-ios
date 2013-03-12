//
//  BBInputViewController.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBButton.h"

@interface BBInputViewController : UIViewController {
	NSMutableSet* touchEvents;
	NSMutableSet* interfaceObjects;
	CGFloat forwardMagnitude;
	CGFloat rightMagnitude;
	CGFloat leftMagnitude;
	BOOL fireMissile;
}

@property (retain) NSMutableSet* touchEvents;
@property (assign) CGFloat forwardMagnitude;
@property (assign) CGFloat rightMagnitude;
@property (assign) CGFloat leftMagnitude;
@property (assign) BOOL fireMissile;

- (void)loadInterface;
- (BOOL)touchesDidBegin;
- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload ;
- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;
- (void)fireButtonDown;
- (void)fireButtonUp;
- (void)leftButtonDown;
- (void)leftButtonUp;
- (void)rightButtonDown;
- (void)rightButtonUp;
- (void)forwardButtonDown;
- (void)forwardButtonUp;

// 7 methods



@end
