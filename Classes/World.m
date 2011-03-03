//
//  World.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "World.h"
#import "Common.h"

@implementation World

@synthesize worldId=_worldId;

- (id) initWith:(int)worldId
{
  if(!(self = [super init])) return nil;
  
  _worldId = worldId;
  
  return self;
}

+ (NSArray *) all
{
  NSMutableArray *worlds = [[NSMutableArray alloc] init];
    
  for (int i = 1; i <= MAX_WORLDS; i++) {
    World *w = [[World alloc] initWith:i];
    [worlds addObject:w];
    [w release];
  }
  
  NSArray *a = [NSArray arrayWithArray:worlds];
  [worlds release];
  return a;
}

@end
