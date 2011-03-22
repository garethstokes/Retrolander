//
//  SpaceBackground.m
//  lander
//
//  Created by gareth stokes on 10/01/11.
//  Copyright 2011 digital five. All rights reserved.
//

#import "SpaceBackground.h"


@implementation SpaceBackground

- (id) init
{
    if (!(self = [super init])) return nil;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Space" ofType:@"plist" inDirectory:@"particles"];

    _particleSystem = [CCParticleSystemQuad particleWithFile:path];
    [self addChild:_particleSystem];

    return self;
}

@end
