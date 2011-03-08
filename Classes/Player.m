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
#import "Common.h"

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
@synthesize booster=_booster;
@synthesize fuel=_fuel;
@synthesize velocityLimit=_velocityLimit;

- (id) initWith:(cpSpace*)worldSpace
{
  if(!(self = [super init])) return nil;
  
  _hasCrashed = NO;
  _hasLanded = NO;
  _isThrusting = NO;
  
  _fuel = MAX_FUEL;
  _velocityLimit = 100;
  
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

- (void) step:(ccTime) delta
{
  if (_isThrusting && _fuel > 0) {
    cpBody *body = _shape->body;
    
    cpVect force = cpvforangle(body->a);
    force = cpvmult(cpvperp(force), 1);    
    cpBodyApplyImpulse(body, force, cpvzero);
    
    //if (abs(body->v.x) <= _velocityLimit 
//        && abs(body->v.y) <= _velocityLimit) 
//    {
      //body;
      _fuel -= delta;
    //}
  }
}



- (void) draw:(cpShape *) shape;
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//draw the ship
	cpPolyShape *poly = (cpPolyShape *)_shape;
	glVertexPointer(2, GL_FLOAT, 0, poly->tVerts);
	glColor4f(0.0f, 0.0f, 1.0f, 1.0f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, poly->numVerts);

	//draw the flame
	glPushMatrix();
  
	if (_isThrusting && _fuel > 0)	{
		glColor4f(0.93359375f, 1.0f, 0.234375f, 1.0f);
		poly = (cpPolyShape *)_booster;
	}else {
		glColor4f(0.93359375f, 0.7109375f, 0.234375f, 1.0f);
		poly = (cpPolyShape *)_flame;
	}

  glVertexPointer(2, GL_FLOAT, 0, poly->tVerts);
	glDrawArrays(GL_TRIANGLE_FAN, 0, poly->numVerts);
	
	glPopMatrix();
	
	// restore default GL state
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}
	

- (void) land
{
  cpShape *playerShape = _shape;
  cpBody *body = playerShape->body;
  cpVect player_velocity = body->v;
  
  if (player_velocity.x > 55 || player_velocity.y > 55) 
  {
    _hasCrashed = YES;
		
		//create explosion and add spinning parts :(
		
    return;
  }
  
	//play you be a winner animation ... yay...
	
	
	
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
	
	cpVect boostTris[] = {
		cpv(-6, -15),
		cpv( 6, -15),
		cpv( 0, -35),
	};
	
	//Booster Flame
	
	cpBody *body = cpBodyNew(0.2f, cpMomentForPoly(1.0f, 3, tris, CGPointZero));
	
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
	body->p = ccp(30, 300);
	cpSpaceAddBody(space, body);
	cpBodySetVelLimit(body, _velocityLimit);
	
	_shape = cpPolyShapeNew(body, 3, tris, CGPointZero);
	_shape->e = 0.0f; 
	_shape->u = 50.0f;
	
	_shape->data = self;
	
	cpSpaceAddShape(space, _shape);
	
	_flame = cpPolyShapeNew(body, 3, flameTris, CGPointZero);
	_flame->e = 0.0f; 
	_flame->u = 50.0f;
	_flame->sensor = cpTrue;
	cpSpaceAddShape(space, _flame);
	
	_booster = cpPolyShapeNew(body, 3, boostTris, CGPointZero);
	_booster->e = 0.0f; 
	_booster->u = 50.0f;
	_booster->sensor = cpTrue;
	cpSpaceAddShape(space, _booster);
}

- (cpVect) position
{
  cpBody *body = _shape->body;
  return body->p;
}

@end
