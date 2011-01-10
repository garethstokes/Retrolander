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

drawSpaceOptions options = {
	0,//Draw Hash
	0,//Draw BBoxes
	1,//Draw Shapes
	0.0f,//Collision Point Size
	0.0f,//Body Point Size
	1.5f//Line Thickness
};

// HelloWorld implementation
@implementation HelloWorld

@synthesize player=_player;
@synthesize landingPad=_landingPad;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void) addPlayer
{
	int posx, posy;
	
	posx = (CCRANDOM_0_1() * 200);
	posy = (CCRANDOM_0_1() * 200);
	
	posx = (posx % 4) * 85;
	posy = (posy % 3) * 121;
	
	cpVect tris[] = {
    cpv(-10,-15),
    cpv(  0, 10),
    cpv( 10,-15),
  };
	
	cpBody *body = cpBodyNew(0.4f, cpMomentForPoly(1.0f, 3, tris, CGPointZero));
  cpBodySetVelLimit(body, 70);
  
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
	body->p = ccp(30, 300);
  //cpBodySetAngle(body, 315 * (3.14159 / 180));
  cpBodySetAngle(body, 3.14159 * 7 / 4);
	cpSpaceAddBody(space, body);
	
	_player = cpPolyShapeNew(body, 3, tris, CGPointZero);
	_player->e = 0.0f; 
  _player->u = 1.5f;
//	//shape->data = tris;
	cpSpaceAddShape(space, _player);
	
}
-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
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
		
    [self createLevel];
    [self addPlayer];
    [self addLandingPad];
    
    [self schedule: @selector(step:)];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
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
  
  for(int i = 0; i < groundPoints.count - 1; i++){
    
    ccDrawLine([[groundPoints objectAtIndex:i] CGPointValue], [[groundPoints objectAtIndex:i + 1] CGPointValue]); 
  }
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
      shape = cpSpaceAddStaticShape(space, cpSegmentShapeNew(staticBody, [[groundPoints objectAtIndex:i] CGPointValue], [[groundPoints objectAtIndex:i + 1] CGPointValue], 0.0f));
      shape->e = 1.0f; 
      shape->u = 5.0f;  
      shape->collision_type = 2;
      
    }
  
}
  
  
-(void) onEnter
{
	[super onEnter];	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	//cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	//cpSpaceHashEach(space->staticShapes, &eachShape, nil);
  
  cpArray *arbiters = space->arbiters;
	BOOL crashed = NO;
  
  for(int i=0; i<arbiters->num; i++){
    cpArbiter *arb = (cpArbiter*)arbiters->arr[i];
    for(int i=0; i<arb->numContacts; i++){
      CP_ARBITER_GET_SHAPES(arb, a, b);
      //if((a == _player) ||(b == _player)){
      if((a != _landingPad) && (b != _landingPad))
      {
        crashed = YES;
      }
      //}
    } 
  }
}

-(void) addLandingPad
{
	int landingPadHeight = 10;
	int landingPadWidth = 40;
	int gap = 1;
	
	int bottomPos = 300;
	int leftPos = 200;
	//int bottomPos = 320;
	//int leftPos = 60;
	
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
	staticBody->p = ccp(bottomPos + (landingPadWidth / 2), leftPos + (landingPadHeight / 2) + gap);
	cpSpaceAddBody(space, staticBody);
	
	_landingPad = cpBoxShapeNew(staticBody, landingPadWidth, landingPadHeight);
	
	cpSpaceAddShape(space, _landingPad);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  cpBody *body = _player->body;
  cpBodyResetForces(body);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  cpBody *body = _player->body;

  cpVect force = cpvforangle(body->a);
  force = cpvmult(cpvperp(force), 80);
  //NSLog(@"force: x:%f y:%f", force.x, force.y);
  NSLog(@"velocity: x:%f y:%f", body->v.x, body->v.y);
  
  cpBodyApplyForce(body, force, cpvzero);
  return YES;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
  #define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	//CGPoint v = ccp( accelX, accelY);
	
  cpBody *body = _player->body;
  float angle = accelY * 4;
  cpBodySetAngle(body, angle - (angle * 2));
	//space->gravity = ccpMult(v, 200);
}
@end
