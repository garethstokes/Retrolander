//
//  Level.h
//  lander
//
//  Created by Richard Owen on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
#import "SpaceBackground.h"

@interface Level : NSObject {
	GameLayer *_gameLayer;
	SpaceBackground *_background;
	NSString *_strPath;
}

@property (nonatomic, retain) GameLayer *gameLayer;
@property (nonatomic, retain) SpaceBackground *background;

- (id) initWithWorldLevelIDs:(int)worldID levelID:(int)levelID;
- (void) load;
- (void) play;
- (void) pause;

@end
