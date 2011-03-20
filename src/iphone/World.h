//
//  World.h
//  lander
//
//  Created by gareth stokes on 3/03/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

@interface World : NSObject {
  int _worldId;
}

@property (nonatomic) int worldId;

- (id) initWith:(int) worldId;
- (NSArray *) levels;
+ (NSArray *) all;

@end
