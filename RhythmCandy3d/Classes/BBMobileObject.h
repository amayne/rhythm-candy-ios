//
//  BBMobileObject.h
//  BBOpenGLGameTemplate
//
//  Created by Andrew Mayne on 23/11/10.
//  Copyright 2010 University of Sydney. All rights reserved.
//
#import "BBSceneObject.h"

@interface BBMobileObject : BBSceneObject {
	BBPoint speed;
	BBPoint rotationalSpeed;
}

@property (assign) BBPoint speed;
@property (assign) BBPoint rotationalSpeed;

@end
