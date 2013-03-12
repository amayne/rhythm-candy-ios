/*
 *  BBPoint.h
 *  BBOpenGLGameTemplate
 *
 *  Created by Andrew Mayne on 23/11/10.
 *  Copyright 2010 University of Sydney. All rights reserved.
 *
 */

typedef struct {
	CGFloat	x, y, z;
} BBPoint;

typedef BBPoint* BBPointPtr;

static inline BBPoint BBPointMake(CGFloat x, CGFloat y, CGFloat z)
{
	return (BBPoint) {x,y,z};
}