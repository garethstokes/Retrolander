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
#import "Common.h"
#import "GameProtocols.h"

@interface Player : CCLayer<GameObject> {
  BOOL _hasCrashed;
  BOOL _hasLanded;
  BOOL _isThrusting;  
  cpShape *_shape;
	cpShape *_flame;
  
  float _fuel;
  int _velocityLimit;
  int _lives;
  
  CCParticleSystemQuad *_flameParticles;
  CCParticleSystemQuad *_exhaust;
  CCParticleSystemQuad *_explosion;
  CCLayer *_parent;
}

@property (nonatomic) BOOL hasCrashed;
@property (nonatomic) BOOL hasLanded;
@property (nonatomic) BOOL isThrusting;
@property (nonatomic) cpShape *shape;
@property (nonatomic) cpShape *flame;
@property (nonatomic) cpShape *booster;
@property (nonatomic) float fuel;
@property (nonatomic) int velocityLimit;
@property (nonatomic) int lives;

- (void) disableThrusting;
- (void) setAngle:(cpFloat)value;
- (void) explode;
- (id) initWith:(cpSpace *)worldSpace andParent:(CCLayer *)parent;
- (cpVect) position;
- (cpFloat) angle;

@end
