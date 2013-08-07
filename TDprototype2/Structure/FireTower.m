//
//  FireTower.m
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FireTower.h"
#import "ConfirmMenu.h"
#import "UpgradeMenu.h"
#import "GameLayer.h"
#import "FightLayer.h"

@implementation FireTower
@synthesize emitter;
Unit* unit;
static int cost = 100;
id fightlayer;
id uilayer;
id menu;
id confirm_menu;
CGSize winSize;
@synthesize dmg;
-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"FireTower.png"]]) {
        [self setSpriteFile:@"FireTower.png"];
//        [self setColor:ccc3(192, 57, 43)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(2, 2)];
        [self setCost:cost];
        [self setTempPosition:point]; 
        [self setName:@"FireTower"];
        [self setPosition:self.tempPosition];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    fightlayer = [[self parent]parent];
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
    self.dmg = 1;
    unit=nil;
    winSize = [[CCDirector sharedDirector]winSize];
}

-(void)onExit
{
    [super onExit];
    [self unscheduleUpdate];
    [self removeAllChildrenWithCleanup:YES];
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
        unit.hp-=dmg;
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
    return 60*dmg;
}

-(NSString*)aoe
{
    return @"Single";
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self createMenuAfterTouch];
    [super handleTapGesture:gesture];
}


@end

@implementation FireTower2
-(void)onEnter
{
    [super onEnter];
    self.dmg = 3;
}
-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self tap:gesture];
}
@end

