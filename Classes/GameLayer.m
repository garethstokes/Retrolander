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
#import "StaticObject.h"

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

    [self addPlayerAndLandingPad];		
    
    [self schedule: @selector(step:)];
		
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)]; 
  }
  return self;
}

static void drawStaticObject(cpShape *shape, GameLayer *gameLayer)
{
  id <GameObject> obj = shape->data;
	[obj draw:shape];
}	

- (void) draw
{
	//[_player draw:_worldSpace];
	
	//[_landingPad draw:_worldSpace];
	
	//loop through the static objects and draw
	cpSpaceHashEach(_worldSpace->activeShapes, (cpSpaceHashIterator)drawStaticObject, self);
	cpSpaceHashEach(_worldSpace->staticShapes, (cpSpaceHashIterator)drawStaticObject, self);
}

- (void) createPhysics
{
  //CGSize wins = [[CCDirector sharedDirector] winSize];
  cpInitChipmunk();
  
  cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
  cpSpace *space = cpSpaceNew();
  cpSpaceResizeStaticHash(space, 400.0f, 40);
  cpSpaceResizeActiveHash(space, 100, 600);
  
  space->gravity = ccp(0, -50);
  space->elasticIterations = space->iterations;
  
  cpShape *shape;
  
  // bottom
  shape = cpSegmentShapeNew(staticBody, 
                            //ccp(0 - (wins.height * 4), 0 - (wins.height * 4)), 
                            ccp(0 - MapWidth, 0- MapHeight),
                            //ccp(wins.width * 4, 0 - (wins.height * 4)), 
                            ccp(MapWidth, 0 - MapHeight),
                            0.0f);
  shape->e = 1.0f; 
  shape->u = 1.0f;
  shape->group = 1;
  cpSpaceAddStaticShape(space, shape);
  
  // top
  shape = cpSegmentShapeNew(staticBody, 
                            //ccp(0 - (wins.height * 4), wins.height * 4), 
                            ccp(0 - MapWidth, MapHeight),
                            //ccp(wins.width * 4, wins.height * 4), 
                            ccp(MapWidth, MapHeight),
                            0.0f);
  shape->e = 1.0f; 
  shape->u = 1.0f;
  shape->group = 1;
  cpSpaceAddStaticShape(space, shape);
  
  // left
  shape = cpSegmentShapeNew(staticBody, 
                            //ccp(0 - (wins.height * 4), 0 - (wins.height * 4)), 
                            ccp(0 - MapWidth, 0 - MapHeight),
                            //ccp(0 - (wins.height * 4), wins.height * 4), 
                            ccp(0 - MapWidth, MapHeight),
                            0.0f);
  shape->e = 1.0f; 
  shape->u = 1.0f;
  shape->group = 1;
  cpSpaceAddStaticShape(space, shape);
  
  // right
  shape = cpSegmentShapeNew(staticBody, 
                            //ccp(wins.width * 4, 0 - (wins.height * 4)), 
                            ccp(MapWidth, 0 - MapHeight),
                            //ccp(wins.width * 4, wins.height * 4), 
                            ccp(MapWidth, MapHeight),
                            0.0f);
  shape->e = 1.0f; 
  shape->u = 1.0f;
  shape->group = 1;
  cpSpaceAddStaticShape(space, shape);
  _worldSpace = space;
}

- (void) loadStaticObjects:(NSDictionary *)dictObjects
{
	NSEnumerator *enumeratorObjects = [dictObjects keyEnumerator];
	id key;
	while ((key = [enumeratorObjects nextObject])) {
		NSArray *stuff = [dictObjects valueForKey: key];
		CGPoint points[[stuff count]];
		NSString *colors[[stuff count]];
		
		for (int i = 0; i < [stuff count]; i++) {
			NSDictionary *dictPoint = [stuff objectAtIndex: i];
			float x = (float)[[dictPoint valueForKey: @"x"] floatValue];
			float y = [[dictPoint valueForKey:@"y"] floatValue];
			colors[i] = [dictPoint valueForKey:@"RGBA"];
			points[i] = CGPointMake(x, y);
		}
		cpShape *shape;
		cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
		
		shape = cpSpaceAddShape(_worldSpace, 
														cpPolyShapeNew(staticBody, 
																					 [stuff count], 
																					 points, 
																					 CGPointZero));
		shape->e = 0.0f; 
		shape->u = 0.0f;  
		shape->group = 1;
		shape->data = [[LevelStaticObject alloc] initWithColors: colors];
		
		[stuff release];
	};	
}

- (void) addPlayerAndLandingPad
{
  _player = [[Player alloc] initWith:_worldSpace andParent:self];
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
	int steps = 5;
	CGFloat dt = delta/(CGFloat)steps;
  
  float distance = ccpDistance([_player position], [_landingPad position]) - 16;
  cpVect offset = ccpAngleBetween([_landingPad position], [_player position]);
  float angle = cpvtoangle(offset);
  
  cpVect middle = ccpGetOffset(angle, distance / 2);
  
  middle = ccpAdd([_landingPad position], middle);
  [self.camera setCenterX:middle.x - 240 centerY:middle.y - 160 centerZ:0];
  [self.camera setEyeX:middle.x - 240 eyeY:middle.y - 160 eyeZ:distance / 3];
  
	for(int i=0; i<steps; i++){
		cpSpaceStep(_worldSpace, dt);
	}
    
  [_player step:delta];
  
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

- (void) pause
{
  [self unschedule: @selector(step:)];	
}

@end
