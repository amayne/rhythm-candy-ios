//
//  BBSceneController.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBSceneObject.h"
#import "BBSpaceShip.h"

@class BBInputViewController;
@class EAGLView;

@interface BBSceneController : NSObject {
	NSMutableArray * sceneObjects;
	NSMutableArray * objectsToAdd;
	NSMutableArray * objectsToRemove;
	
	BBInputViewController * inputController;
	EAGLView * openGLView;
	
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
}

@property (retain) BBInputViewController * inputController;
@property (retain) EAGLView * openGLView;

@property NSTimeInterval animationInterval;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (BBSceneController*)sharedSceneController;
- (void) dealloc;
- (void) loadScene;
- (void) startScene;
- (void)gameLoop;
- (void)renderScene;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;
- (void)addObjectToScene:(BBSceneObject*)sceneObject;
- (void)removeObjectFromScene:(BBSceneObject*)sceneObject;

// 11 methods

@end
