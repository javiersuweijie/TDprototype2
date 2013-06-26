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
        self.speed = 50;
        self.speedMultiplier = 1;
        self.color = ccc3(100, 100, 120);
        self.hp = 100;
        self.unitType = Flying;
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
        [self moveToward:pointTo];
    }
    return self;
}

-(NSMutableArray*)moveToward:(CGPoint)target
{
    float timetaken=ccpDistance(self.position, target)/self.speed;
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:target];
    id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, nil] speed:self.speedMultiplier];
	// Remove the step
	[self runAction:speeding];
    return nil;
}

@end
