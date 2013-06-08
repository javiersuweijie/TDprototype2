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
    if (self = [super initWithFile:@"redbox.png"]) {
        [self setPosition:point];
        [self moveToward:pointTo];
        [self setAnchorPoint:ccp(0.5,0)];
        [self schedule:@selector(updateZ:)];
        self.speed = 50;
    }
    return self;
}

-(void)updateZ:(ccTime)dt
{
    [parent_ reorderChild:self z:-self.position.y];
//    if (self.hp<0) {
    
//        [[IsoBackground getCharArray] removeObject:self];
//        [self removeFromParentAndCleanup:YES];
//    }
}

@end
