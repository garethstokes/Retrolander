//
//  ChoseLevelScene.h
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"


@interface ChooseLevelScene : CCScene {
  int _worldId;
}

@property (nonatomic) int worldId;

+ (id) sceneWith:(int) worldId;

@end
