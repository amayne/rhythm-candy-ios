//
//  BBSceneController.m
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "EAGLView.h"
#import "BBSceneObject.h"

@implementation BBSceneController

@synthesize inputController, openGLView;
@synthesize animationInterval, animationTimer;

// Singleton accessor.  this is how you should ALWAYS get a reference
// to the scene controller.  Never init your own. 
+(BBSceneController*)sharedSceneController
{
  static BBSceneController *sharedSceneController;
  @synchronized(self)
  {
    if (!sharedSceneController)
      sharedSceneController = [[BBSceneController alloc] init];
	}
	return sharedSceneController;
}


#pragma mark scene preload

// this is where we initialize all our scene objects
-(void)loadScene
{
	// this is where we store all our objects
	sceneObjects = [[NSMutableArray alloc] init];
	
	BBSpaceShip * ship = [[BBSpaceShip alloc] init];
	ship.scale = BBPointMake(2.5, 2.5, 1.0);
	[self addObjectToScene:ship];
	[ship release];
	[inputController loadInterface];
}

-(void) startScene
{
	self.animationInterval = 1.0/60.0;
	[self startAnimation];
}

#pragma mark Game Loop

- (void)gameLoop
{
	NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
	if([objectsToAdd count] > 0) {
		[sceneObjects addObjectsFromArray:objectsToAdd];
		[objectsToAdd removeAllObjects];
	}
	
	// apply our inputs to the objects in the scene
	[self updateModel];
	// send our objects to the renderer
	[self renderScene];
	
	if([objectsToRemove count] > 0) {
		[sceneObjects removeObjectsInArray:objectsToRemove];
		[objectsToRemove removeAllObjects];
	}
	
	[apool release];
}

- (void)updateModel
{
	// simply call 'update' on all our scene objects
	[inputController updateInterface];
	[sceneObjects makeObjectsPerformSelector:@selector(update)];
	// be sure to clear the events
	[inputController clearEvents];
}

- (void)renderScene
{
	// turn openGL 'on' for this frame
	[openGLView beginDraw];
	// simply call 'render' on all our scene objects
	[sceneObjects makeObjectsPerformSelector:@selector(render)];
	// draw the interface ontop of everything
	[inputController renderInterface];
	// finalize this frame
	[openGLView finishDraw];
}


#pragma mark Animation Timer

// these methods are copied over from the EAGLView template

- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}

- (void)addObjectToScene:(BBSceneObject *)sceneObject
{
	if(objectsToAdd == nil)
		objectsToAdd = [[NSMutableArray alloc] init];
	sceneObject.active = YES;
	[sceneObject awake];
	[objectsToAdd addObject:sceneObject];
}

- (void)removeObjectFromScene:(BBSceneObject *)sceneObject
{
	if(objectsToRemove == nil)
		objectsToRemove = [[NSMutableArray alloc] init];
	[objectsToRemove addObject:sceneObject];
}
#pragma mark dealloc

- (void) dealloc
{
	[self stopAnimation];
	[super dealloc];
}


@end
