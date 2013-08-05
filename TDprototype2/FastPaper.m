//
//  FastPaper.m
//  TDprototype2
//
//  Created by Javiersu on 23/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FastPaper.h"


@implementation FastPaper

-(id)initWithPosition:(CGPoint)point moveTo:(CGPoint)pointTo
{
    if (self = [super initWithFile:@"whiteball.png"]) {
        self.speed = 80;
        self.speedMultiplier = 1;
        self.color = ccc3(0, 120, 200);
        self.hp = 200;
        self.unitType = Normal;
        self.bounty = 10;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
//        [self moveToward:pointTo];
        [self performSelectorInBackground:@selector(moveToward:) withObject:[NSValue valueWithCGPoint:pointTo]];
    }
    return self;
}

@end
