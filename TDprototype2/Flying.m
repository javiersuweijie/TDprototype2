//
//  Flying.m
//  TDprototype2
//
//  Created by Javiersu on 23/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Flying.h"


@implementation FlyingUnit

-(id)initWithPosition:(CGPoint)point moveTo:(CGPoint)pointTo
{
    if (self = [super initWithFile:@"whiteball.png"]) {
        self.speed = 20;
        self.speedMultiplier = 1;
        self.color = ccc3(100, 0, 200);
        self.hp = 1000;
        self.unitType = Normal;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
        [self moveToward:pointTo];
    }
    return self;
}

@end
