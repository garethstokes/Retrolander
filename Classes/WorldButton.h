//
//  WorldButton.h
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"


@interface WorldButton : CCLayer<CCTargetedTouchDelegate> {
  int _number;
  CCLabelTTF *_text;
}

@property (nonatomic) int number;

- (id) initWith:(int) num;
- (CGRect) rect;

@end
