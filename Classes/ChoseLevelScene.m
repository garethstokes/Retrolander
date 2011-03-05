//
//  ChoseLevelScene.m
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "ChoseLevelScene.h"
#import "LevelButton.h"
#import "Common.h"
#import "World.h"
#import "Level.h"

@implementation ChoseLevelScene

@synthesize worldId=_worldId;

+ (id) sceneWith:(int) worldId
{
  ChoseLevelScene *scene = [ChoseLevelScene node];
  scene.worldId = worldId;
  
  // set the heading.
  CCLabelTTF *heading = [CCLabelTTF labelWithString:@"Choose a level" fontName:@"Helvetica" fontSize:32];
  [heading setPosition:CGPointMake(240, 300)];
  [scene addChild:heading];
  
  // bind the levels to the sceen.
  World *world = [[World alloc] initWith:worldId];
  int y_level = 1;
  for (Level* level in [world levels]){
    LevelButton *button = [[LevelButton alloc] initWith:worldId levelId:[level levelId]];
    int offset = [level levelId] % 4;
    int x = 120 * (offset == 0 ? 4 : offset) - 60;
    int y = 240 - (80 * y_level - 40);
    if (offset == 0) y_level++;
    
    [button setPosition:CGPointMake(x, y)];
    [scene addChild:button];
  }
  
  return scene;
}

@end
