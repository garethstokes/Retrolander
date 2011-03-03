//
//  ChoseWorldScene.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "ChoseWorldScene.h"
#import "World.h"
#import "WorldButton.h"

@implementation ChoseWorldScene

+ (id) scene
{
  ChoseWorldScene *scene = [ChoseWorldScene node];
  NSArray *worlds = [World all];
  
  for (World *w in worlds)
  {
    WorldButton *button = [[WorldButton alloc] initWith:w.worldId];
    int x = 120 * (w.worldId > 4 ? w.worldId - 4 : w.worldId) - 60;
    int y = w.worldId > 4 ? 50 : 150;
    [button setPosition:CGPointMake(x, y)];
    [scene addChild:button];
  }
  
  return scene;
}

@end
