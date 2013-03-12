//
//  BBMobileObject.m
//  BBOpenGLGameTemplate
//
//  Created by Andrew Mayne on 23/11/10.
//  Copyright 2010 University of Sydney. All rights reserved.
//

#import "BBMobileObject.h"


@implementation BBMobileObject

-(void)update
{
	translation.x += speed.x;
	translation.y += speed.y;
	translation.z += speed.z;
	
	rotation.x += rotationalSpeed.x;
	rotation.y += rotationalSpeed.y;
	rotation.z += rotationalSpeed.z;
	[self checkArenaBounds];
	[super update];
}

-(void)checkArenaBounds
{
	if (translation.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0)) translation.x -= 480.0 + CGRectGetWidth(self.meshBounds); 
	if (translation.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0)) translation.x += 480.0 + CGRectGetWidth(self.meshBounds); 
	
	if (translation.y > (160.0 + CGRectGetHeight(self.meshBounds)/2.0)) translation.y -= 320.0 + CGRectGetHeight(self.meshBounds); 
	if (translation.y < (-160.0 - CGRectGetHeight(self.meshBounds)/2.0)) translation.y += 320.0 + CGRectGetHeight(self.meshBounds); 
}

@end
