//
//  Player.m
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "Player.h"
#import "chipmunk.h"
#import "drawSpace.h"

@interface Player(Private)
- (void) setupPysicsWith:(cpSpace*)space;
@end

drawSpaceOptions _options = {
	0,//Draw Hash
	0,//Draw BBoxes
	1,//Draw Shapes
	4.0f,//Collision Point Size
	0.0f,//Body Point Size
	1.5f//Line Thickness
};

@implementation Player
@synthesize hasCrashed=_hasCrashed;
@synthesize hasLanded=_hasLanded;
@synthesize isThrusting=_isThrusting;
@synthesize shape=_shape;
@synthesize flame=_flame;

- (id) initWith:(cpSpace*)worldSpace
{
  if(!(self = [super init])) return nil;
  
  _hasCrashed = NO;
  _hasLanded = NO;
  _isThrusting = NO;
  
  [self setupPysicsWith:worldSpace];
  
  return self;
}

- (void) disableThrusting
{
  [self setIsThrusting:NO];
  cpBody *body = _shape->body;
	cpBodyResetForces(body);
}

- (void) setAngle:(cpFloat)value
{
  cpBody *body = _shape->body;
  cpBodySetAngle(body, value);
}

- (void) step
{
  if (_isThrusting) {
    cpBody *body = _shape->body;
    
    cpVect force = cpvforangle(body->a);
    force = cpvmult(cpvperp(force), 1);    
    cpBodyApplyImpulse(body, force, cpvzero);
  }
}



- (void) draw:(cpSpace *)space
{
	drawSpace(space, &_options);
	
	//draw the ship
	
	//draw the flame
	
	
}
	

- (void) land
{
  cpShape *playerShape = _shape;
  cpBody *body = playerShape->body;
  cpVect player_velocity = body->v;
  
  if (player_velocity.x > 55 || player_velocity.y > 55) 
  {
    _hasCrashed = YES;
    return;
  }
  
  _hasLanded = YES; 
}

- (void) setupPysicsWith:(cpSpace*)space
{
  cpVect tris[] = {
    cpv(-10,-15),
    cpv(  0, 10),
    cpv( 10,-15),
  };
	
	cpVect flameTris[] = {
		cpv(-6, -15),
		cpv( 6, -15),
		cpv( 0, -25),
	};
	
	//Booster Flame
	
	cpBody *body = cpBodyNew(0.2f, cpMomentForPoly(1.0f, 3, tris, CGPointZero));
	
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
	body->p = ccp(30, 300);
	cpSpaceAddBody(space, body);
	cpBodySetVelLimit(body, 100);
	
	_shape = cpPolyShapeNew(body, 3, tris, CGPointZero);
	_shape->e = 0.0f; 
	_shape->u = 50.0f;
	cpSpaceAddShape(space, _shape);
	
	_flame = cpPolyShapeNew(body, 3, flameTris, CGPointZero);
	_flame->e = 0.0f; 
	_flame->u = 50.0f;
	_flame->sensor = cpTrue;
	cpSpaceAddShape(space, _flame);
}

@end
