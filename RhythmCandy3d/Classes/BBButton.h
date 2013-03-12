//
//  BBButton.h
//  BBOpenGLGameTemplate
//
//  Created by Andrew Mayne on 23/11/10.
//  Copyright 2010 University of Sydney. All rights reserved.
//

#import "BBSceneObject.h"
#import "BBMesh.h"
#import "BBSceneController.h"
#import "BBInputViewController.h"


@interface BBButton : BBSceneObject {
	BOOL pressed;
	id target;
	SEL buttonDownAction;
	SEL buttonUpAction;
	CGRect	screenRect;
}

@property (assign) id target;
@property (assign) SEL buttonDownAction;
@property (assign) SEL buttonUpAction;

-(void) handleTouches;
-(void) touchUp;
-(void) touchDown;
-(void) setPressedVertexes;
-(void) setNotPressedVertexes;
@end
