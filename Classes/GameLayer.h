//
//  GameLayer.h
//  lander
//
//  Created by gareth stokes on 26/12/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "LandingPad.h"


@interface GameLayer : CCLayer {
  Player *_player;
  LandingPad *_landingPad;
  
  CCLabelTTF *_label;
  cpSpace *_worldSpace;
  NSArray *_groundPoints;
}

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) LandingPad *landingPad;

- (void) createPhysics;
- (void) mapTerrain;
- (void) addPlayerAndLandingPad;
@end