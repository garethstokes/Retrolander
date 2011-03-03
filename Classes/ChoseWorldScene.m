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
  
  // set the heading.
  CCLabelTTF *heading = [CCLabelTTF labelWithString:@"Choose a World" fontName:@"Helvetica" fontSize:32];
  [heading setPosition:CGPointMake(240, 300)];
  [scene addChild:heading];
  
  // bind the worlds.
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
