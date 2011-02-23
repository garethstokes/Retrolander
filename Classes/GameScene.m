//
//  GameScene.m
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "GameScene.h"
#import "Level.h"
#import "GameHud.h"

@implementation Game

@synthesize game=_game;

+ (id) scene
{
  Game *scene = [Game node];
  GameHud *hud = [[GameHud alloc] init];

	Level *level = [[Level alloc] initWithWorldLevelIDs:1 levelID:1];
	[level load];
	
  [scene setGame: level.gameLayer];

  [scene addChild:hud z:100];
  [scene addChild:level.gameLayer z:1];
  [scene addChild:level.background z:0];

  return scene;
}

@end
