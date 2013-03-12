//
//  BBSpaceShip.m
//  BBOpenGLGameTemplate
//
//  Created by Andrew Mayne on 23/11/10.
//  Copyright 2010 University of Sydney. All rights reserved.
//

#import "BBSpaceShip.h"

#pragma mark Space Ship

static NSInteger BBSpaceShipVertexStride = 2;
static NSInteger BBSpaceShipColorStride = 4;

static NSInteger BBSpaceShipOutlineVertexesCount = 5;
static CGFloat BBSpaceShipOutlineVertexes[10] = {0.0,4.0,3.0,-4.0,1.0,-2.0,1.0,-2.0,-3.0,-4.0};

static CGFloat BBSpaceShipColorValues[20] = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0};

@implementation BBSpaceShip

-(void)awake
{
	mesh = [[BBMesh alloc] initWithVertexes:BBSpaceShipOutlineVertexes
								vertexCount:BBSpaceShipOutlineVertexesCount 
							   vertexStride:BBSpaceShipVertexStride
								renderStyle:GL_LINE_LOOP];
	mesh.colors = BBSpaceShipColorValues;
	mesh.colorStride = BBSpaceShipColorStride;
}

-(void)update
{
	[super update];
	CGFloat rightTurn = [[BBSceneController sharedSceneController].inputController rightMagnitude];
	CGFloat leftTurn = [[BBSceneController sharedSceneController].inputController leftMagnitude];
	
	rotation.z += ((rightTurn * -1.0) + leftTurn) * TURN_SPEED_FACTOR;
	
	if([[BBSceneController sharedSceneController].inputController fireMissile])
		[self fireMissile];
	
	CGFloat forwardMag = [[BBSceneController sharedSceneController].inputController forwardMagnitude] * THRUST_SPEED_FACTOR;
	if(forwardMag <= 0.0001)
		return;
	CGFloat radians = rotation.z/BBRADIANS_TO_DEGREES;
	
	speed.x += sinf(radians) * -forwardMag;
	speed.y += cosf(radians) * forwardMag;
}

-(void)fireMissile
{
	[[BBSceneController sharedSceneController].inputController setFireMissile:NO];
}

@end
