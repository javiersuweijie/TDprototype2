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
        self.bounty = 10;
        [self setAnchorPoint:ccp(0.5,-0.3)];
        [self setPosition:point];
        [self moveTowards:pointTo];
//        [self performSelectorInBackground:@selector(moveToward:) withObject:[NSValue valueWithCGPoint:pointTo]];
    }
    return self;
}

-(NSMutableArray*)moveTowards:(CGPoint)target
{
    float timetaken=ccpDistance(self.position, target)/self.speed;
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:target];
    id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(reachEnd)]; // set the method itself as the callback
    id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, moveCallback, nil] speed:self.speedMultiplier];
	// Remove the step
	[self runAction:speeding];
    return nil;
}

-(void)update:(ccTime)dt
{
    if (self.hp<0) {
        [[GameLayer getUnitArray] removeObject:self];
        [self removeFromParentAndCleanup:YES];
        
    }
}

@end
