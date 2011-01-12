//
//  HelloWorldScene.m
//  Astrolander
//
//  Created by gareth stokes on 10/12/10.
//  Copyright digital five 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "drawSpace.h"
#import "CCTouchDispatcher.h"
#include "chipmunk.h"
#include "GameHud.h"

drawSpaceOptions options = {
	0,//Draw Hash
	0,//Draw BBoxes
	1,//Draw Shapes
	4.0f,//Collision Point Size
	0.0f,//Body Point Size
	1.5f//Line Thickness
};

// HelloWorld implementation
@implementation HelloWorld

@synthesize player=_player;
@synthesize landingPad=_landingPad;
@synthesize label = _label;
@synthesize hasCrashed=_hasCrashed;
@synthesize hasLanded=_hasLanded;
@synthesize isThrusting=_isThrusting;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *game = [HelloWorld node];
  GameHud *hud = [GameHud node];
	
	// add layer as a child to scene
	[scene addChild:game z:1];
  [scene addChild:hud z:100];
	
	// return the scene
	return scene;
}


-(void) addPlayer
{
	cpVect tris[] = {
    cpv(-10,-15),
    cpv(  0, 10),
    cpv( 10,-15),
  };
	
	cpBody *body = cpBodyNew(0.2f, cpMomentForPoly(1.0f, 3, tris, CGPointZero));
	
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
	body->p = ccp(30, 300);
	cpSpaceAddBody(space, body);
  cpBodySetVelLimit(body, 100);
	
	_player = cpPolyShapeNew(body, 3, tris, CGPointZero);
	_player->e = 0.0f; 
	_player->u = 50.0f;
	//	//shape->data = tris;
	cpSpaceAddShape(space, _player);
	
}

- (void) createPhysicsWorld
{
  CGSize wins = [[CCDirector sharedDirector] winSize];
  cpInitChipmunk();
  
  cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
  space = cpSpaceNew();
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
}

-(id) init
{
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
    // create and initialize a Label
    CGSize size = [[CCDirector sharedDirector] winSize];
		_label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:18];
		_label.position = ccp( size.width/ 2, size.height - 20 );
		[self addChild: _label];
		
		[self createPhysicsWorld];
		[self createLevel];		
		[self addPlayer];		
    
		[self schedule: @selector(step:)];
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)]; 
    
    _hasCrashed = NO;
    _hasLanded = NO;
    _isThrusting = NO;
	}
	
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) draw
{
	drawSpace(space, &options);
	
	//drawPolyShape(landingPad->body, (cpPolyShape *)_landingPad, space);
	
	for(int i = 0; i < groundPoints.count - 1; i++){
		
		ccDrawLine([[groundPoints objectAtIndex:i] CGPointValue], [[groundPoints objectAtIndex:i + 1] CGPointValue]); 
	}
  
  [_label setString:[NSString stringWithFormat:@"Crashed Status: %s, Landed Status: %s", _hasCrashed ? "YES" : "NO", _hasLanded ? "YES" : "NO"]];
}

-(void) addLandingPad
{
	cpVect first = ccp(290, 230);
	cpVect second = ccp(330, 230);
  
//  cpVect first = ccp(10, 230);
//	cpVect second = ccp(50, 230);
  
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);

	_landingPad = cpSegmentShapeNew(staticBody, first, second, 2.0f);
	_landingPad->e = 1.0f;
	_landingPad->u = 5000.0f;
	_landingPad->collision_type = 2;
	
	cpSpaceAddStaticShape(space, _landingPad);
}

- (void) createLevel
{
    //load in level to play
    //[groundPoints insertObject:[NSMutableArray arrayWithObjects:ccp(0, 10),ccp(50, 100),ccp( ),ccp( ),ccp(),ccp(),nil] atIndex:0];
    
    groundPoints = [[NSArray arrayWithObjects:
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
    
    for(int i = 0; i < groundPoints.count - 1 ; i++){
		//create segment
		// add some other segments to play with
		shape = cpSpaceAddShape(space, cpSegmentShapeNew(staticBody, [[groundPoints objectAtIndex:i] CGPointValue], [[groundPoints objectAtIndex:i + 1] CGPointValue], 0.0f));
		shape->e = 0.0f; 
		shape->u = 1.0f;  
		shape->collision_type = 2;
		
    }
}   


-(void) onEnter
{
	[super onEnter];	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
  
  if (_isThrusting) {
    cpBody *body = _player->body;
    
    cpVect force = cpvforangle(body->a);
    force = cpvmult(cpvperp(force), 1);
    //NSLog(@"force: x:%f y:%f", force.x, force.y);
    //NSLog(@"velocity: x:%f y:%f", body->v.x, body->v.y);
    
    cpBodyApplyImpulse(body, force, cpvzero);
  }
	
	//cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	//cpSpaceHashEach(space->staticShapes, &eachShape, nil);
	
	cpArray *arbiters = space->arbiters;
	
	for(int i=0; i<arbiters->num; i++){
		 
		cpArbiter *arb = (cpArbiter*)arbiters->arr[i];
		
		for(int i=0; i<arb->numContacts; i++){
			CP_ARBITER_GET_SHAPES(arb, a, b);
			if((a != _landingPad) && (b != _landingPad))
			{
				_hasCrashed = YES;
			}
      
      if ((a == _player) && (b == _landingPad)) {
        cpBody *body = _player->body;
        cpVect player_velocity = body->v;
        //NSLog(@"player velocity: %f", player_velocity);
        if (player_velocity.x > 55 || player_velocity.y > 55) {
          _hasCrashed = YES;
        }
        _hasLanded = YES;
      }
		}
	}
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	_isThrusting = NO;
	cpBody *body = _player->body;
	cpBodyResetForces(body);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (_hasLanded) return YES;
  _isThrusting = YES;
  return YES;  
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	if (_hasLanded) return;
	static float prevX=0, prevY=0;
	
	#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
  
  NSLog(@"rotation x:%f y:%f", accelX, accelY);
	
  cpBody *body = _player->body;
  float angle = accelY * 4;
  cpBodySetAngle(body, angle - (angle * 2));
}

@end
