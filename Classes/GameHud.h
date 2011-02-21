//
//  GameHud.h
//  lander
//
//  Created by gareth stokes on 25/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// RESTART BUTTON
@interface RestartButton : CCLayer<CCTargetedTouchDelegate>
{
  CCLabelTTF *_text;
}

@property (nonatomic, retain) CCLabelTTF *text;

- (CGRect) rect;
@end

// FUEL GAUGE
@interface FuelGauge : CCNode
{
  int _maxFuel;
}

- (id) initWithMax:(int)fuel;
- (void) draw:(int) playerFuel;

@end

@interface GameHud : CCLayerColor
{
  FuelGauge *_fuel;
}

@end
