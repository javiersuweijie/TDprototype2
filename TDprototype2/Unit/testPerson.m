//
//  testPerson.m
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "testPerson.h"


@implementation testPerson
-(id)initWithPosition:(CGPoint)point moveTo:(CGPoint)pointTo
{
    if (self = [super initWithFile:@"whiteball.png"]) {
        self.speed = 50;
        self.speedMultiplier = 1;
        self.color = ccc3(255, 0, 0);
        self.hp = 200;
        self.unitType=Normal;
        self.bounty = 10;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setScale:0.75];
        [self setPosition:point];
//        [self moveToward:pointTo];
        [self performSelectorInBackground:@selector(moveToward:) withObject:[NSValue valueWithCGPoint:pointTo]];
    }
    return self;
}

@end
