//
//  LanderButton.h
//  lander
//
//  Created by gareth stokes on 8/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"


@interface LanderImageButton : CCMenuItemImage {
  int _worldId;
  int _levelId;
}

@property (nonatomic) int worldId;
@property (nonatomic) int levelId;

@end
