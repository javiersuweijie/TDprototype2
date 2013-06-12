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
    if (self = [super initWithFile:@"ball.png"]) {
        self.speed = 50;
        self.speedMultiplier = 1;
        self.hp = 200;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
        [self moveToward:pointTo];
    }
    return self;
}



@end
