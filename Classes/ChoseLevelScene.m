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

@implementation ChoseLevelScene

@synthesize worldId=_worldId;

+ (id) sceneWith:(int) worldId
{
  ChoseLevelScene *scene = [ChoseLevelScene node];
  scene.worldId = worldId;
  
  int y_level = 1;
  for (int i = 1; i <= MAX_LEVELS; i++)
  {
    LevelButton *button = [[LevelButton alloc] initWith:worldId levelId:i];
    int offset = i % 4;
    int x = 120 * (offset == 0 ? 4 : offset) - 60;
    int y = 240 - (80 * y_level - 40);
    if (offset == 0) y_level++;
    
    [button setPosition:CGPointMake(x, y)];
    [scene addChild:button];
  }
  
  return scene;
}

@end
