//
//  Level.m
//  lander
//
//  Created by Richard Owen on 23/02/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize gameLayer=_gameLayer;
@synthesize background=_background;

- (id) initWithWorldLevelIDs:(int)worldID levelID:(int)levelID
{
	if(!(self = [super init])) return nil;
	
	NSString *strWorldID = [NSString stringWithFormat:@"world_%d", worldID];
	NSString *strLevelID = [NSString stringWithFormat:@"level_%d", levelID];
	
	_strPath = [NSString stringWithFormat:@"%s\\%s", strWorldID, strLevelID];
	_gameLayer = nil;
	_background = nil;
	
	return self;	
}

- (void) load
{
	_gameLayer = [[GameLayer alloc] init];
	_background = [[SpaceBackground alloc] init];

	//Load in the plist and start processing the stuff
	NSString *strPLISTFilename = [[NSBundle mainBundle] pathForResource:@"level" ofType:@"plist" inDirectory:_strPath];
	NSDictionary *dictLevel = [[NSDictionary alloc] initWithContentsOfFile:strPLISTFilename];
	
	//Load in the level details
	
	
	//Load in Static objects
	NSDictionary *dictObjects = [dictLevel objectForKey: @"StaticObjects"];
	[_gameLayer loadStaticObjects: dictObjects];
	
	//Release loading objects
	[dictObjects release];
	[dictLevel release];	
}

- (void) play
{
	
}

- (void) pause
{
}

- (void)dealloc {
	
	[_gameLayer release];
	[_background release];
	
	[super dealloc];
}

@end
