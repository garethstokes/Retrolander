//
//  LandingPad.m
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "LandingPad.h"
#import "chipmunk.h"

@interface LandingPad(Private)

@end


@implementation LandingPad
@synthesize shape=_shape;

- (id) initAgainst:(cpSpace*)worldSpace
{
  if(!(self=[super init])) return nil;
  
  cpVect first = ccp(290, 230);
	cpVect second = ccp(330, 230);
  
  //  cpVect first = ccp(10, 230);
  //	cpVect second = ccp(50, 230);
  
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
  
  _shape = cpSegmentShapeNew(staticBody, first, second, 2.0f);
  _shape->e = 1.0f;
  _shape->u = 5000.0f;
  _shape->collision_type = 2;
	
	cpSpaceAddStaticShape(worldSpace, _shape);
  
  return self;
}

@end
