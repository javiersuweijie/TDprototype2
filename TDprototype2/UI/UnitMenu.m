//
//  UnitMenu.m
//  TDprototype2
//
//  Created by Javiersu on 30/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UnitMenu.h"
#import "CustomMenuItem.h"
#import "GameLayer.h"

@implementation UnitMenu
id game_layer;
id confirm_menu;
CGSize winSize;
-(id)init
{
    float left_padding = 5;
    CustomMenuItem * menuItem1 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do1Action)];
    [menuItem1 setScale:0.7];
    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Normal" fontName:@"Helvetica" fontSize:8];
    [label1 setAnchorPoint:ccp(0,0)];
    [label1 setPosition:ccp(left_padding, 0)];
    [menuItem1 addChild:label1];
    
    CustomMenuItem * menuItem2 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do2Action)];
    [menuItem2 setScale:0.7];
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Fast" fontName:@"Helvetica" fontSize:8];
    [label2 setAnchorPoint:ccp(0,0)];
    [label2 setPosition:ccp(left_padding, 0)];
    [menuItem2 addChild:label2];
    
    CustomMenuItem * menuItem3 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do3Action)];
    [menuItem3 setScale:0.7];
    CCLabelTTF* label3 = [CCLabelTTF labelWithString:@"Thick" fontName:@"Helvetica" fontSize:8];
    [label3 setAnchorPoint:ccp(0,0)];
    [label3 setPosition:ccp(left_padding, 0)];
    [menuItem3 addChild:label3];
    
    CustomMenuItem * menuItem4 = [CustomMenuItem menuItemWithOnlyImage:@"button.png" target:self selector:@selector(do4Action)];
    [menuItem4 setScale:0.7];
    CCLabelTTF* label4 = [CCLabelTTF labelWithString:@"Flying" fontName:@"Helvetica" fontSize:8];
    [label4 setAnchorPoint:ccp(0,0)];
    [label4 setPosition:ccp(left_padding, 0)];
    [menuItem4 addChild:label4];
    winSize = [[CCDirector sharedDirector]winSize];
    NSArray* menuArray = [[NSArray alloc]initWithObjects:menuItem4,menuItem3,menuItem2,menuItem1 ,nil];
    
    return [super initWithArray:menuArray];
    
}

-(void)onEnter
{
    [super onEnter];
    self.radius = 30;
    game_layer = [[[self parent]parent]getChildByTag:1];
    [self setPosition:ccp(winSize.width/40*30, winSize.height/30*8)];
    [self arrangeCircle];
}

-(void) do1Action
{
    [game_layer testSP];
}
-(void) do2Action
{
    [game_layer spawnFastPaper];
}
-(void) do3Action
{
    [game_layer spawnSlowThick];
}
-(void) do4Action
{
    [game_layer spawnFlyingUnit];
}

@end
