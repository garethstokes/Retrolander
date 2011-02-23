//
//  EntryScene.h
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"
#import "StartGameButton.h"

@interface EntryScene : CCScene {
  StartGameButton *_start;
}

@property (nonatomic, retain) StartGameButton *start;

+ (id) scene;

@end
