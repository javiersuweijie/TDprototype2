//
//  DummyTower.m
//  TDprototype2
//
//  Created by Javiersu on 21/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DummyTower.h"
#import "IsometricOperator.h"
#import "GameLayer.h"
#import "ConfirmMenu.h"
#import "Structure Menu.h"
#import "UpgradeMenu.h"

@implementation DummyTower
static int cost = 0;
id uilayer;
id menu;
id confirm_menu;
id gamelayer;
CGSize winSize;
-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"psuedoisobox2.png"]]) {
        [self setColor:ccc3(127, 140, 141)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(2, 2)];
        [self setCost:cost];
        [self setPosition:point];
        [self setName:@"DummyTower"];
        [self setCanBeMoved:NO];
        winSize = [[CCDirector sharedDirector]winSize];

    }
    return self;
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (!gamelayer) {
        gamelayer = [[self parent] parent];
    }
    if (!uilayer) {
        uilayer = [[gamelayer parent]getChildByTag:2];
    }
    CGPoint touchLocation = self.position;
    NSLog(@"%@",NSStringFromCGPoint([IsometricOperator gridNumber:touchLocation]));
    touchLocation = ccpAdd(touchLocation, ccp(0,11.31*2));
    
    menu = [[[gamelayer parent]getChildByTag:2]getChildByTag:1];
    confirm_menu = [[[gamelayer parent]getChildByTag:2]getChildByTag:2];
    if ([[[menu children]objectAtIndex:0] numberOfRunningActions]>0) {
        return;
    }
    if ([confirm_menu isSelected]) {
        return;
    }
    if ([gamelayer closeMenu]);
    else {
        if ([Structure isSelectedGlobally]) {
            return;
        }
        UpgradeMenu* upgrademenu = [[UpgradeMenu alloc]initWithCurrent:self andStrings:@"FireTower", @"CanonTower", @"IceBeamTower", nil];
        [uilayer addChild:upgrademenu z:3 tag:3];
        CGPoint mid = [gamelayer convertToNodeSpace:ccp(winSize.width/2,winSize.height/2)];
        CGPoint moveby = ccpMult(ccpSub(mid, touchLocation),[gamelayer getScale]);
        float dist = ccpDistance(ccp(0,0), moveby);
        id move = [CCMoveBy actionWithDuration:dist/700 position:moveby];
        id ease = [CCEaseOut actionWithAction:move rate:0.5];
        id popMenu = [CCCallFunc actionWithTarget:upgrademenu selector:@selector(arrangeCircle)];
        [gamelayer runAction:[CCSequence actions:ease, popMenu, nil]];
    }
}

@end
