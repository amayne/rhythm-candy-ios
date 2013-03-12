//
//  EAGLView.m
//  BBOpenGLIntro
//
//  Created by ben smith on 21/06/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithFrame:(CGRect)rect {
    
    if ((self = [super initWithFrame:rect])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        self.multipleTouchEnabled = YES;
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		
		}
    return self;
}


- (void)setupView
{		
	// Set up the window that we will view the scene through
	glViewport(0, 0, backingWidth, backingHeight);
	
	// switch to the projection matrix and setup our 'camera lens'
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);	

	// switch to model mode and set our background color
	glMatrixMode(GL_MODELVIEW);
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}

- (void)setupViewLandscape
{
	// set up matrices and transforms for OpenGL ES
	glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	// set up the view port so that it is analogous to the screen pixels
	glOrthof(-backingHeight/2.0, backingHeight/2.0, -backingWidth/2.0, backingWidth/2.0, -1.0f, 1.0f);
	
	glMatrixMode(GL_MODELVIEW);
	
	// clear the view with black
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}
-(void)beginDraw
{
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	// make sure we are in model matrix mode and clear the frame
	glMatrixMode(GL_MODELVIEW);
	glClear(GL_COLOR_BUFFER_BIT);
	// set a clean transform
	glLoadIdentity();	
}

-(void)finishDraw
{
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];	
}

- (void)layoutSubviews 
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self setupViewLandscape];
}

- (BOOL)createFramebuffer {    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


-(void)perspectiveFovY:(GLfloat)fovY 
								aspect:(GLfloat)aspect 
								 zNear:(GLfloat)zNear
									zFar:(GLfloat)zFar 
{
	const GLfloat pi = 3.1415926;
	//	Half of the size of the x and y clipping planes.
	// - halfWidth = left, halfWidth = right
	// - halfHeight = bottom, halfHeight = top
	GLfloat halfWidth, halfHeight;
	//	Calculate the distance from 0 of the y clipping plane. Basically trig to calculate
	//	position of clip plane at zNear.
	halfHeight = tan( (fovY / 2) / 180 * pi ) * zNear;	
	//	Calculate the distance from 0 of the x clipping plane based on the aspect ratio.
	halfWidth = halfHeight * aspect;
	//	Finally call glFrustum with our calculated values.
	glFrustumf( -halfWidth, halfWidth, -halfHeight, halfHeight, zNear, zFar );
}



- (void)dealloc {
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
