//
//  HelloWorldScene.m
//  Astrolander
//
//  Created by gareth stokes on 10/12/10.
//  Copyright digital five 2010. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk headers
#import "chipmunk.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	cpSpace *space;
  cpShape *_player;
  NSArray *groundPoints; 
  cpShape *_landingPad;
}

@property (nonatomic) cpShape *player;
@property (nonatomic) cpShape *landingPad;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) step: (ccTime) dt;
-(void) addPlayer;
-(void) createLevel; 
-(void) addLandingPad;

@end
