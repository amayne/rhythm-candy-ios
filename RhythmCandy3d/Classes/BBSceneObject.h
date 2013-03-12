//
//  BBSceneObject.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#include "BBPoint.h"

@class BBMesh;

@interface BBSceneObject : NSObject {
	// transform values
	BBPoint translation;
	BBPoint rotation;
	BBPoint scale;
	
	BBMesh * mesh;
	CGRect meshBounds;
	
	BOOL active;
}

@property (assign) BBPoint translation;
@property (assign) BBPoint rotation;
@property (assign) BBPoint scale;
@property (assign) CGRect meshBounds;

@property (assign) BOOL active;

- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;
- (CGRect) meshBounds;


@end
