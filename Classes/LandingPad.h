//
//  LandingPad.h
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface LandingPad : NSObject {
cpShape *_shape;
}

@property (nonatomic) cpShape* shape;

- (id) initAgainst:(cpSpace *)worldSpace;

@end
