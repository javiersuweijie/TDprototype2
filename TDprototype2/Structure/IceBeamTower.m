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
#import "FightLayer.h"

@implementation IceBeamTower
@synthesize emitter;

Unit* unit;
static int cost = 300;
id fightLayer;

-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"Water.png"]]) {
        [self setSpriteFile:@"Water.png"];
//        [self setColor:ccc3(52, 152, 219)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(2, 2)];
        [self setCost:cost];
        [self setTempPosition:point];
        [self setName:@"IceBeamTower"];
        [self setPosition:point];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    fightLayer = [[self parent]parent];
    emitter=[[ParticlesIceBeam alloc]init];
    [emitter setPosition:ccp(self.contentSize.width/2,self.contentSize.height/2)];
    [emitter stopSystem];
    [self addChild:emitter];
    [self scheduleUpdate];
    unit=nil;
}

-(void)update:(ccTime)dt
{
    if ([self.array count]>0) {
        for (Unit* unitt in self.array) {
            if (ccpDistance(self.position,unitt.position)<75) {
                unit = unitt;
                break;
            }
            else if ([self.array indexOfObject:unitt]==[self.array count]-1) {
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

+(int)cost
{
    return cost;
}

-(float)dps
{
    return (int)60;
}
-(NSString*)aoe
{
    return @"Single";
}
@end
