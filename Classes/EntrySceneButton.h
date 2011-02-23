//
//  EntrySceneButton.h
//  lander
//
//  Created by gareth stokes on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"

@interface EntrySceneButton : CCLayer<CCTargetedTouchDelegate>
{
  CCLabelTTF *_text;
}

@property (nonatomic, retain) CCLabelTTF *text;

- (CGRect) rect;
- (id) initForHud;

@end