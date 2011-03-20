//
//  ScoreCard.h
//  lander
//
//  Created by Richard Owen on 9/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreCard : CCScene {
	int _worldID;
	int _levelID;
}

@property (nonatomic) int worldID;
@property (nonatomic) int levelID;

+(id) scene:(int)worldID levelID:(int)levelID fuelLevel:(int)fuelLevel timeLeft:(int)timeLeft;

- (void)nextLevelButtonTapped:(id)sender;
- (void)GotoNextLevel;

@end
