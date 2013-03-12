//
//  BBOpenGLGameTemplateAppDelegate.m
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BBOpenGLGameTemplateAppDelegate.h"

#import "BBInputViewController.h"
#import "EAGLView.h"
#import "BBSceneController.h"

@implementation BBOpenGLGameTemplateAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	BBSceneController * sceneController = [BBSceneController sharedSceneController];
	
	// make a new input view controller, and save it as an instance variable
	BBInputViewController * anInputController = [[BBInputViewController alloc] initWithNibName:nil bundle:nil];
	sceneController.inputController = anInputController;
	[anInputController release];
	
	// init our main EAGLView with the same bounds as the window
	EAGLView * glView = [[EAGLView alloc] initWithFrame:window.bounds];
	sceneController.inputController.view = glView;
	sceneController.openGLView = glView;
	[glView release];
	
	// set our view as the first window view
	[window addSubview:sceneController.inputController.view];
	[window makeKeyAndVisible];
	
	// begin the game.
	[sceneController loadScene];
	[sceneController startScene];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
