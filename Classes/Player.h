//
//  Player.h
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface Player : NSObject {
  BOOL _hasCrashed;
  BOOL _hasLanded;
  BOOL _isThrusting;  
  cpShape *_shape;
	cpShape *_flame;
}

@property (nonatomic) BOOL hasCrashed;
@property (nonatomic) BOOL hasLanded;
@property (nonatomic) BOOL isThrusting;
@property (nonatomic) cpShape *shape;
@property (nonatomic) cpShape *flame;
@property (nonatomic) cpShape *booster;

- (void) disableThrusting;
- (void) setAngle:(cpFloat)value;
- (void) step;
- (void) land;
- (id) initWith:(cpSpace *)worldSpace;
- (void) draw:(cpSpace *)space;

@end
