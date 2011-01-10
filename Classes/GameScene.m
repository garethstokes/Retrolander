//
//  GameScene.m
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "GameScene.h"
#import "GameHud.h"
#import "GameLayer.h"
#import "SpaceBackground.h"

@implementation Game

+ (id) scene
{
  CCScene *scene = [CCScene node];
  
  GameHud *hud = [[GameHud alloc] init];
  GameLayer *game = [[GameLayer alloc] init];
  SpaceBackground *background = [[SpaceBackground alloc] init];

  [scene addChild:hud z:100];
  [scene addChild:game z:1];
  [scene addChild:background z:0];
  
  return scene;
}

@end
