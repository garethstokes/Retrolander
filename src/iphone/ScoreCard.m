//
//  ScoreCard.m
//  lander
//
//  Created by Richard Owen on 9/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "ScoreCard.h"
#import "CCSprite.h"
#import "Common.h"
#import	"GameScene.h"


@implementation ScoreCard

@synthesize	worldID=_worldID;
@synthesize levelID=_levelID;

-(id) init
{
	if((self = [super init]))
	{
		//background
		CCSprite *background = [CCSprite spriteWithFile:@"ScoreCardBackground.png"];
		background.position = ccp(240, 160);
		[self addChild:background];
		
		//addmenu
		NSLog(@"Creating Menu");
		CCMenuItemImage *nextMenuItem = [CCMenuItemImage itemFromNormalImage:@"btnNextLevel.png" selectedImage:@"btnNextLevel.png" target:self selector:@selector(nextLevelButtonTapped:)];
		nextMenuItem.position = ccp(240, 60);

		NSLog(@"Menu Item created");
		
		CCMenu *nextMenu = [CCMenu menuWithItems:nextMenuItem, nil];
		nextMenu.position = CGPointZero;

		[self addChild:nextMenu];
	}
	
	return self;
}

- (void) GotoNextLevel
{
	if (_levelID < MAX_LEVELS){
		[[CCDirector sharedDirector] replaceScene:[Game scene:_worldID levelID:_levelID+1]];
	} else {
		if(_worldID < MAX_WORLDS){
			//World Complete show story here
			
			[[CCDirector sharedDirector] replaceScene:[Game scene:_worldID+1 levelID:1]];
		}
		else{
			//Game over woot!
		}
	}
	
}

- (void)nextLevelButtonTapped:(id)sender
{
	[self GotoNextLevel ];
}
	
+ (id) scene:(int)worldID levelID:(int)levelID fuelLevel:(int)fuelLevel timeLeft:(int)timeLeft
{
	ScoreCard *ascene = [ScoreCard node];
	
	[ascene setWorldID:worldID];
	[ascene setLevelID:levelID];
	
	return ascene;
}

@end
