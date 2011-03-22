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
#import "GameScene.h"
#import "ScoreCard.h"

@implementation GameLayer
@synthesize player=_player;
@synthesize landingPad=_landingPad;

- (id) init
{
  if ((self=[super init]))
  {
    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
      [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)]; 
    #endif
      
    // create and initialize a Label
    CGSize size = [[CCDirector sharedDirector] winSize];
    _label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:18];
    _label.position = ccp( size.width /2, 20 );
    [self addChild: _label];

    [self createPhysics];		

    [self addPlayerAndLandingPad];		
    
    [self schedule: @selector(step:)];
		
    
      
      _cameraPosition = [_player position];
      [self.camera setCenterX:_cameraPosition.x - 240 centerY:_cameraPosition.y - 160 centerZ:0];
      [self.camera setEyeX:_cameraPosition.x - 240 eyeY:_cameraPosition.y - 160 eyeZ:90];
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

-(void) onEnter
{
	[super onEnter];
	#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
    #endif
}

- (void) CheckForCrash
{
	cpArray *arbiters = _worldSpace->arbiters;
	
	int LandingPadContactCount = 0;
	
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
        //[_player land];
				cpShape *playerShape = _player.shape;
				cpBody *body = playerShape->body;
				cpVect player_velocity = body->v;
	
        NSLog(@"player_velocity: (%f, %f)", player_velocity.x * -1, player_velocity.y * -1);
        
				if (player_velocity.x > 9.0f 
            || player_velocity.y > 9.0f
            || player_velocity.x < -9.0f
            || player_velocity.y < -9.0f) 
				{
					[_player setHasCrashed:YES];
					
					//create explosion and add spinning parts :(
					
					return;
				}
				
				if(++LandingPadContactCount == 2){
					
					//play you be a winner animation ... yay...
					[self pause];
				
					//Show level score
				
					Game *g = (Game *)[[CCDirector sharedDirector] runningScene];
				
					int thisWorldID = g.worldID;
					int thislevelID = g.levelID;
				
					[[CCDirector sharedDirector] replaceScene:[ScoreCard scene:thisWorldID levelID:thislevelID fuelLevel:_player.fuel timeLeft:30]];
								
					[_player setHasLanded:YES ];
				
					break;
				}
      }
		}
	} 
}

-(void) step: (ccTime) delta
{
    if ([_player hasCrashed]) 
    {
        [_player explode];
        return;
    }

    int steps = 5;
    CGFloat dt = delta/(CGFloat)steps;


    for(int i=0; i<steps; i++){
        cpSpaceStep(_worldSpace, dt);
    }

    [self CheckForCrash];
    [_player step:delta];
    [self moveCameraTo:[_player position]];
}

- (void) moveCameraTo:(CGPoint)point
{
    float magnitude = ccpDistance(_cameraPosition, point);
    NSLog(@"magnitude: %f", magnitude);
    
    if (magnitude > 100) 
    {
        cpVect offset = ccpAngleBetween(_cameraPosition, point);
        float angle = cpvtoangle(offset);
        CGPoint delta = ccpGetOffset(angle, magnitude - 100);
        _cameraPosition = ccpAdd(_cameraPosition, delta);
     
        [self.camera setCenterX:_cameraPosition.x - 240 centerY:_cameraPosition.y - 160 centerZ:0];
        [self.camera setEyeX:_cameraPosition.x - 240 eyeY:_cameraPosition.y - 160 eyeZ:90];
    }
}

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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

#endif

- (void) pause
{
  [self unschedule: @selector(step:)];	
}

@end
