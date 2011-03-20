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
@synthesize hud=_hud;
@synthesize level=_level;
@synthesize levelID=_levelID;
@synthesize worldID=_worldID;

+ (id) scene:(int)worldID levelID:(int)levelID
{
  Game *scene = [Game node];
  scene.hud = [[GameHud alloc] init];
	
	scene.levelID = levelID;
	scene.worldID = worldID;

	scene.level = [[Level alloc] initWithWorldLevelIDs:worldID levelID:levelID];
	[scene.level load];
	
  [scene setGame: scene.level.gameLayer];

  [scene addChild:scene.hud z:100];
  [scene addChild:scene.level.gameLayer z:5];
  [scene addChild:scene.level.background z:0];

  return scene;
}

- (void) dealloc
{
	[_hud release];
	[_level release];
	
	[super dealloc];
}


@end
