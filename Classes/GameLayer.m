//
//  GameLayer.m
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "GameLayer.h"
#import "CCTouchDispatcher.h"
#import "chipmunk.h"

@implementation GameLayer
@synthesize player=_player;
@synthesize landingPad=_landingPad;

- (id) init
{
  if ((self=[super init]))
  {
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    
    // create and initialize a Label
    CGSize size = [[CCDirector sharedDirector] winSize];
    _label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:18];
    _label.position = ccp( size.width /2, 20 );
    [self addChild: _label];

    [self createPhysics];
    [self mapTerrain];		
    [self addPlayerAndLandingPad];		
    
    [self schedule: @selector(step:)];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)]; 
  }
  return self;
}

- (void) draw
{
	[_player draw:_worldSpace];
	
	for(int i = 0; i < _groundPoints.count - 1; i++)
  {
		ccDrawLine([[_groundPoints objectAtIndex:i] CGPointValue], 
               [[_groundPoints objectAtIndex:i + 1] CGPointValue]); 
	}
  
  [_label setString:[NSString stringWithFormat:@"Crashed Status: %s, Landed Status: %s", 
                                               [_player hasCrashed] ? "YES" : "NO", 
                                               [_player hasLanded] ? "YES" : "NO"]];
}

- (void) createPhysics
{
  CGSize wins = [[CCDirector sharedDirector] winSize];
  cpInitChipmunk();
  
  cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
  cpSpace *space = cpSpaceNew();
  cpSpaceResizeStaticHash(space, 400.0f, 40);
  cpSpaceResizeActiveHash(space, 100, 600);
  
  space->gravity = ccp(0, -50);
  space->elasticIterations = space->iterations;
  
  cpShape *shape;
  
  // bottom
  shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(wins.width,0), 0.0f);
  shape->e = 1.0f; shape->u = 1.0f;
  cpSpaceAddStaticShape(space, shape);
  
  // top
  shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
  shape->e = 1.0f; shape->u = 1.0f;
  cpSpaceAddStaticShape(space, shape);
  
  // left
  shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
  shape->e = 1.0f; shape->u = 1.0f;
  cpSpaceAddStaticShape(space, shape);
  
  // right
  shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
  shape->e = 1.0f; shape->u = 1.0f;
  cpSpaceAddStaticShape(space, shape);
  _worldSpace = space;
}

- (void) mapTerrain
{
  _groundPoints = [[NSArray arrayWithObjects:
                   [NSValue valueWithCGPoint:CGPointMake(0, 10)],
                   [NSValue valueWithCGPoint:CGPointMake(30, 100)],
                   [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                   [NSValue valueWithCGPoint:CGPointMake(120, 200)],
                   [NSValue valueWithCGPoint:CGPointMake(160, 200)],
                   [NSValue valueWithCGPoint:CGPointMake(180, 180)],
                   [NSValue valueWithCGPoint:CGPointMake(200, 180)],
                   [NSValue valueWithCGPoint:CGPointMake(240, 190)],
                   [NSValue valueWithCGPoint:CGPointMake(260, 190)],
                   [NSValue valueWithCGPoint:CGPointMake(320, 60)],
                   [NSValue valueWithCGPoint:CGPointMake(360, 60)],
                   [NSValue valueWithCGPoint:CGPointMake(360, 190)],
                   [NSValue valueWithCGPoint:CGPointMake(370, 190)],
                   [NSValue valueWithCGPoint:CGPointMake(480, 300)],
                   nil] retain];
	
	
  
  cpShape *shape;
  cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
  
  for(int i = 0; i < _groundPoints.count - 1 ; i++){
		//create segment
		// add some other segments to play with
		shape = cpSpaceAddShape(_worldSpace, 
                            cpSegmentShapeNew(staticBody, 
                                              [[_groundPoints objectAtIndex:i] CGPointValue], 
                                              [[_groundPoints objectAtIndex:i + 1] CGPointValue], 
                                              0.0f));
		shape->e = 0.0f; 
		shape->u = 1.0f;  
		shape->collision_type = 2;
  }
}

- (void) addPlayerAndLandingPad
{
  _player = [[Player alloc] initWith:_worldSpace];
  _landingPad = [[LandingPad alloc] initAgainst:_worldSpace];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) onEnter
{
	[super onEnter];	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
}

-(void) step: (ccTime) delta
{
  if ([_player hasCrashed]) return;
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(_worldSpace, dt);
	}
    
  [_player step];
  
  cpArray *arbiters = _worldSpace->arbiters;
	
	for(int i=0; i<arbiters->num; i++){
    
		cpArbiter *arb = (cpArbiter*)arbiters->arr[i];
		
		for(int i=0; i<arb->numContacts; i++){
			CP_ARBITER_GET_SHAPES(arb, a, b);
			if((a != [_landingPad shape]) && (b != [_landingPad shape]))
			{
				[_player setHasCrashed:YES];
			}
      
      if ((a == [_player shape]) && (b == [_landingPad shape])) 
      {
        [_player land];
      }
		}
	} 
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[_player setIsThrusting:NO];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if ([_player hasLanded]) return YES;
  [_player setIsThrusting:YES];
  return YES;  
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
  if ([_player hasLanded]) return;
  static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
  
  float angle = accelY * 4;
  [_player setAngle:angle - (angle * 2)];
}

@end
