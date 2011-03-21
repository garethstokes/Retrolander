//
//  worldeditorAppDelegate.h
//  worldeditor
//
//  Created by gareth stokes on 21/03/11.
//  Copyright digital five 2011. All rights reserved.
//

#import "cocos2d.h"

@interface worldeditorAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
