//
//  landerAppDelegate.h
//  lander
//
//  Created by gareth stokes on 21/12/10.
//  Copyright digital five 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface landerAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
