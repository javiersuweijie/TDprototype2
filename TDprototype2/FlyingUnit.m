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
        [self setStartPoint:point];
        [self setEndPoint:pointTo];
    }
    return self;
}

-(NSMutableArray*)moveToward:(NSValue*)target
{
    CGPoint targetPoint = [target CGPointValue];
    float timetaken=ccpDistance(self.position, targetPoint)/self.speed;
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:targetPoint];
    id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(reachEnd)]; // set the method itself as the callback
    id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, moveCallback, nil] speed:self.speedMultiplier];
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
