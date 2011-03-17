//
//  WorldEditorAppDelegate.h
//  WorldEditor
//
//  Created by gareth stokes on 17/03/11.
//  Copyright 2011 digital five. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WorldEditorAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
