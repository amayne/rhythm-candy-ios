//
//  BBMesh.m
//  SpaceRocks
//
//  Created by ben smith on 3/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBMesh.h"


@implementation BBMesh

@synthesize vertexCount,vertexStride,colorStride,renderStyle,vertexes,colors;

- (id)initWithVertexes:(CGFloat*)verts 
		   vertexCount:(NSInteger)vertCount 
		  vertexStride:(NSInteger)vertStride
		   renderStyle:(GLenum)style;
{
	self = [super init];
	if (self != nil) {
		self.vertexes = verts;
		self.vertexCount = vertCount;
		self.vertexStride = vertStride;
		self.renderStyle = style;
	}
	return self;
}

// called once every frame
-(void)render
{
	// load arrays into the engine
	glVertexPointer(vertexStride, GL_FLOAT, 0, vertexes);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(colorStride, GL_FLOAT, 0, colors);	
	glEnableClientState(GL_COLOR_ARRAY);
	
	//render
	glDrawArrays(renderStyle, 0, vertexCount);	
}


+(CGRect)meshBounds:(BBMesh*)mesh scale:(BBPoint)scale
{
	if (mesh == nil) return CGRectZero;
	// need to run through my vertexes and find my extremes
	if (mesh.vertexCount < 2) return CGRectZero;
	CGFloat xMin,yMin,xMax,yMax;
	xMin = xMax = mesh.vertexes[0];
	yMin = yMax = mesh.vertexes[1];
	NSInteger index;
	for (index = 0; index < mesh.vertexCount; index++) {
		NSInteger position = index * mesh.vertexStride;
		if (xMin > mesh.vertexes[position] * scale.x) xMin = mesh.vertexes[position] * scale.x;
		if (xMax < mesh.vertexes[position] * scale.x) xMax = mesh.vertexes[position] * scale.x;
		if (yMin > mesh.vertexes[position + 1] * scale.y) yMin = mesh.vertexes[position + 1] * scale.y;
		if (yMax < mesh.vertexes[position + 1] * scale.y) yMax = mesh.vertexes[position + 1] * scale.y;
	}
	CGRect meshBounds = CGRectMake(xMin, yMin, xMax - xMin, yMax - yMin);
	if (CGRectGetWidth(meshBounds) < 1.0) meshBounds.size.width = 1.0;
	if (CGRectGetHeight(meshBounds) < 1.0) meshBounds.size.height = 1.0;
	return meshBounds;
}

- (void) dealloc
{
	[super dealloc];
}



@end
