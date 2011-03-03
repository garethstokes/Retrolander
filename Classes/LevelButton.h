//
//  LevelButton.h
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"

@interface LevelButton : CCLayer<CCTargetedTouchDelegate> {
  int _worldId;
  int _levelId;
  CCLabelTTF *_text;
}

@property (nonatomic) int worldId;
@property (nonatomic) int levelId;

- (id) initWith:(int) worldId levelId:(int)levelId;
- (CGRect) rect;

@end

