//
//  HelloWorldScene.m
//  AstroLender
//
//  Created by Richard Owen on 13/12/10.
//  Copyright Digital Five 2010. All rights reserved.
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
	cpShape *_landingPad;
	CCLabelTTF *_label; 
	NSArray *groundPoints;
  bool _hasCrashed;
  bool _hasLanded;
  bool _isThrusting;
}

@property (nonatomic) cpShape *player;
@property (nonatomic) cpShape *landingPad;
@property (nonatomic) bool hasCrashed;
@property (nonatomic) bool hasLanded;
@property (nonatomic) bool isThrusting;
@property (nonatomic, retain) CCLabelTTF *label; 

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) step: (ccTime) dt;
-(void) addPlayer;
-(void) addLandingPad;
-(void) createLevel;
-(void) createPhysicsWorld;

@end
