//
//  FireTower.m
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FireTower.h"

@implementation FireTower
@synthesize emitter;
NSMutableArray* array;
Unit* unit;


-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"whitebox.png"]]) {
        [self setColor:ccc3(243, 136, 136)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(1, 1)];
        [self setPosition:point];
        [self setName:@"firetower"];
        [self setCanBeMoved:YES];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    array = [GameLayer getUnitArray];
    emitter=[[CCParticleFire alloc]init];
    [emitter stopSystem];
    emitter.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    emitter.posVar = ccp(0,0);
    emitter.startSize = 5;
    emitter.totalParticles = 50;
    emitter.life = 1;
    emitter.speed = 20;
    emitter.positionType = kCCPositionTypeGrouped;
    [self addChild:emitter];
    [self scheduleUpdate];
    unit=nil;
}

-(void)update:(ccTime)dt
{
    if ([array count]>0) {
        for (Unit* unitt in array) {
            if (ccpDistance(self.position,unitt.position)<75) {
                unit = unitt;
                break;
            }
            else if ([array indexOfObject:unitt]==[array count]-1) {
                unit= nil;
                [emitter stopSystem];
            }
        }
        if (!emitter.active && unit!=nil)[emitter resetSystem];
        emitter.gravity = ccpSub(unit.position,self.position);
        emitter.angle = CC_RADIANS_TO_DEGREES(ccpAngleSigned(ccp(1,0),ccpSub(unit.position,self.position)));
        unit.hp--;
    }
    else if (emitter.active) {
        [emitter stopSystem];
        unit=nil;
    }
}
@end

