//
//  IceBeamTower.m
//  TDprototype2
//
//  Created by Javiersu on 11/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "IceBeamTower.h"
#import "GameLayer.h"
#import "ParticlesIceBeam.h"

@implementation IceBeamTower
@synthesize emitter;

NSArray* array;
Unit* unit;

-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"redbox.png"]]) {
        [self setColor:ccBLUE];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(1, 1)];
        [self setPosition:point];
        [self setName:@"icetower"];
        [self setCanBeMoved:YES];
        [self scheduleUpdate];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    array = [GameLayer getUnitArray];
    emitter=[[ParticlesIceBeam alloc]init];
    [emitter setPosition:ccp(self.contentSize.width/2,self.contentSize.height/2)];
    [emitter stopSystem];
    [self addChild:emitter];
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
        CGPoint dist = ccpSub(unit.position,self.position);
        emitter.life = ccpDistance(ccp(0,0), dist)/emitter.speed;
        unit.speedMultiplier = 0.5;
        unit.hp--;
    }
    else if (emitter.active) {
        [emitter stopSystem];
        unit=nil;
    }
}
@end
