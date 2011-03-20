//
//  GameScene.h
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "GameHud.h"
#import "Level.h"

@interface Game : CCScene {
	GameHud *_hud;
	Level		*_level;
	int _levelID;
	int _worldID;
}

@property (nonatomic, retain) GameLayer *game;
@property (nonatomic, retain) GameHud *hud;
@property (nonatomic, retain) Level *level;
@property (nonatomic) int levelID;
@property (nonatomic) int worldID;

+ (id) scene:(int)worldID levelID:(int)levelID;

@end
