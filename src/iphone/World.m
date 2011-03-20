//
//  World.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "World.h"
#import "Common.h"
#import "Level.h"

@implementation World

@synthesize worldId=_worldId;

- (id) initWith:(int)worldId
{
  if(!(self = [super init])) return nil;
  
  _worldId = worldId;
  
  return self;
}

- (NSArray *) levels
{
  NSMutableArray *levels = [[NSMutableArray alloc] init];
  
  for (int i = 1; i <= MAX_LEVELS; i++) {
    Level *level = [[Level alloc] initWithWorldLevelIDs:_worldId levelID:i];
    [levels addObject:level];
    [level release];
  }
  
  NSArray *a = [NSArray arrayWithArray:levels];
  [levels release];
  return a;
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
