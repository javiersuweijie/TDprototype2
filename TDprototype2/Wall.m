//
//  Wall.m
//  TDprototype2
//
//  Created by Javiersu on 28/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Wall.h"
#import "GameLayer.h"
#import "IsometricOperator.h"

@implementation Wall
static int cost = 0;
static NSMutableArray* wallArray;
static NSMutableDictionary* midWallDict;
id filledNode;

-(id)initWithPosition:(CGPoint)point
{
    if (!wallArray) {
        wallArray = [[NSMutableArray alloc]init];
    }
    if (!midWallDict) {
        midWallDict = [[NSMutableDictionary alloc]init];
    }
    if ([super initWithFile:[NSString stringWithFormat:@"Wall.png"]]) {
        [self setSpriteFile:@"Wall.png"];
//        [self setColor:ccc3(189, 195, 199)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(1, 1)];
        [self setCost:cost];
        [self setPosition:point];
        [self setName:@"Wall"];
        [self setCanBeMoved:YES];
        [wallArray addObject:self];
    }
    return self;
}
-(void)onEnter
{
    [super onEnter];
    filledNode = [self parent];
}

-(void)setPosition:(CGPoint)position
{
    [self removeMidWall];
    [super setPosition:position];
    [self checkAdj];
}

-(void)checkAdj
{
    CGPoint selfGrid = [self getGrid];
    for (Wall* wall in wallArray) {
        if ([wall isEqual:self]) {
            continue;
        }
        if (CGPointEqualToPoint([wall getGrid],ccpAdd(selfGrid, ccp(0,1)))) {
            CCSprite* midWall = [CCSprite spriteWithFile:@"WallCRight.png"];
            [midWall setPosition:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-1,2))])];
            [filledNode addChild:midWall z:-self.position.y-self.contentSize.height/4];
            [midWallDict setObject:midWall forKey:[NSValue valueWithCGPoint:midWall.position]];
        }
        if (CGPointEqualToPoint([wall getGrid],ccpAdd(selfGrid, ccp(1,0)))) {
            NSLog(@"found adj wall1");
            CCSprite* midWall = [CCSprite spriteWithFile:@"WallCLeft.png"];
            [midWall setPosition:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(0,1))])];
            [filledNode addChild:midWall z:-self.position.y+self.contentSize.height/4];
            [midWallDict setObject:midWall forKey:[NSValue valueWithCGPoint:midWall.position]];
        }
        if (CGPointEqualToPoint([wall getGrid],ccpAdd(selfGrid, ccp(-1,0)))) {
            NSLog(@"found adj wall1");
            CCSprite* midWall = [CCSprite spriteWithFile:@"WallCLeft.png"];
            [midWall setPosition:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-2,1))])];
            [filledNode addChild:midWall z:-self.position.y-self.contentSize.height/4];
            [midWallDict setObject:midWall forKey:[NSValue valueWithCGPoint:midWall.position]];
        }
        if (CGPointEqualToPoint([wall getGrid],ccpAdd(selfGrid, ccp(0,-1)))) {
            NSLog(@"found adj wall1");
            CCSprite* midWall = [CCSprite spriteWithFile:@"WallCRight.png"];
            [midWall setPosition:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-1,0))])];
            [filledNode addChild:midWall z:-self.position.y+self.contentSize.height/4];
            [midWallDict setObject:midWall forKey:[NSValue valueWithCGPoint:midWall.position]];
        }
    }
}

-(CGPoint)getGrid
{
    return [IsometricOperator gridNumber:self.position];
}

-(void)removeMidWall
{
    CGPoint selfGrid = [self getGrid];
    NSArray* array = [NSArray arrayWithObjects:
                      [NSValue valueWithCGPoint:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-1,0))])],
                      [NSValue valueWithCGPoint:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-2,1))])],
                      [NSValue valueWithCGPoint:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(0,1))])],
                      [NSValue valueWithCGPoint:ccpMidpoint(self.position, [IsometricOperator gridToCoord:ccpAdd(selfGrid, ccp(-1,2))])],
                      nil];
    
    for (id value in array) {
        id midWall = [midWallDict objectForKey:value];
        if (midWall) {
//            [midWallDict removeObjectForKey:value];
            [midWall removeFromParentAndCleanup:YES];
        }
    }
}
@end
