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

@implementation FireTower
@synthesize emitter;
NSMutableArray* array;
Unit* unit;
static int cost = 100;
float dmg;
id gamelayer;
id uilayer;
id menu;
id confirm_menu;
CGSize winSize;

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
        [self setCanBeMoved:YES];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self setPosition:self.tempPosition];
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
    dmg = 1;
    unit=nil;
    winSize = [[CCDirector sharedDirector]winSize];
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

-(int)dps
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
    dmg = 10;
}
-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self tap:gesture];
}
@end

