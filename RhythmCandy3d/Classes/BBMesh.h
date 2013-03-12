//
//  BBMesh.h
//  SpaceRocks
//
//  Created by ben smith on 3/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "BBPoint.h"

@interface BBMesh : NSObject {
	// mesh data
	GLfloat * vertexes;
	GLfloat * colors;
	
	GLenum renderStyle;
	NSInteger vertexCount;
	NSInteger vertexStride;
	NSInteger colorStride;	
	
}

@property (assign) NSInteger vertexCount;
@property (assign) NSInteger vertexStride;
@property (assign) NSInteger colorStride;
@property (assign) GLenum renderStyle;

@property (assign) GLfloat * vertexes;
@property (assign) GLfloat * colors;

- (id)initWithVertexes:(CGFloat*)verts 
		   vertexCount:(NSInteger)vertCount 
		  vertexStride:(NSInteger)vertStride
		   renderStyle:(GLenum)style;

+(CGRect)meshBounds:(BBMesh*)mesh scale:(BBPoint)scale;

-(void)render;

@end
