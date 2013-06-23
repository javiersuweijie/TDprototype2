//
//  FlyingUnit.m
//  TDprototype2
//
//  Created by Javiersu on 23/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FlyingUnit.h"


@implementation FlyingUnit

-(id)initWithPosition:(CGPoint)point moveTo:(CGPoint)pointTo
{
    if (self = [super initWithFile:@"whiteball.png"]) {
        self.speed = 20;
        self.speedMultiplier = 1;
        self.color = ccc3(100, 120, 0);
        self.hp = 1000;
        self.unitType = Flying;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
        [self moveToward:pointTo];
    }
    return self;
}

@end
