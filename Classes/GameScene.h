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

@interface Game : CCScene {
  GameLayer *_game;
}

@property (nonatomic, retain) GameLayer *game;

+ (id) scene;

@end
