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
#import "GameProtocols.h"

@interface LandingPad : NSObject <GameObject> {
cpShape *_shape;
}

@property (nonatomic) cpShape* shape;

- (id) initAgainst:(cpSpace *)worldSpace;
- (cpVect) position;

@end
