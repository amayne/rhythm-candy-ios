//
//  BBSceneObject.m
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBSceneObject.h"
#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "BBMesh.h"

#pragma mark Spinny Square mesh
static CGFloat spinnySquareVertices[8] = {
-0.5f, -0.5f,
0.5f,  -0.5f,
-0.5f,  0.5f,
0.5f,   0.5f,
};

static CGFloat spinnySquareColors[16] = {
1.0, 1.0,   0, 1.0,
0,   1.0, 1.0, 1.0,
0,     0,   0,   0,
1.0,   0, 1.0, 1.0,
};


@implementation BBSceneObject

@synthesize translation,rotation,scale,active,meshBounds;

- (id) init
{
	self = [super init];
	if (self != nil) {
		translation = BBPointMake(0.0, 0.0, 0.0);
		rotation = BBPointMake(0.0, 0.0, 0.0);
		scale = BBPointMake(1.0, 1.0, 1.0);
		meshBounds = CGRectZero;
		active = NO;
	}
	return self;
}

// called once when the object is first created.
-(void)awake
{
	mesh = [[BBMesh alloc] initWithVertexes:spinnySquareVertices 
								vertexCount:4 
							   vertexStride:2
								renderStyle:GL_TRIANGLE_STRIP];
	mesh.colors = spinnySquareColors;
	mesh.colorStride = 4;
}

// called once every frame
-(void)update
{
	// subclasses can ovverride this for their own purposes
}

// called once every frame
-(void)render
{
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	
	// move to my position
	glTranslatef(translation.x, translation.y, translation.z);
	
	// rotate
	glRotatef(rotation.x, 1.0f, 0.0f, 0.0f);
	glRotatef(rotation.y, 0.0f, 1.0f, 0.0f);
	glRotatef(rotation.z, 0.0f, 0.0f, 1.0f);
	
	//scale
	glScalef(scale.x, scale.y, scale.z);
	
	[mesh render];
	
	//restore the matrix
	glPopMatrix();
}

-(CGRect) meshBounds
{
	if(CGRectEqualToRect(meshBounds, CGRectZero))
		meshBounds = [BBMesh meshBounds:mesh scale:scale];
	return meshBounds;
}

- (void) dealloc
{
	[super dealloc];
}

@end
