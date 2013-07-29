//
//  InfoPanel.m
//  TDprototype2
//
//  Created by Javiersu on 29/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "InfoPanel.h"
#import "Structure.h"

@implementation InfoPanel
CCSprite* info_base;
CGSize winSize;
float horiGrid;
float vertGrid;
id structure_;

-(id)initWithStructure:(Structure*)structure
{
    if (self = [self init]) {
        structure_ = structure;
    }
    return self;
}

-(id)init
{
    if (self = [super init]) {
        winSize = [[CCDirector sharedDirector]winSize];
        info_base = [CCSprite spriteWithFile:@"info-base.png"];
        [info_base setAnchorPoint:ccp(0,0)];
        [info_base setPosition:ccp(winSize.width/40,winSize.height/30)];
        [self addChild:info_base];
        
        horiGrid = info_base.contentSize.width/22;
        vertGrid = info_base.contentSize.height/16;
        NSLog(@"%@",NSStringFromCGSize(info_base.contentSize));
    }
    return self;
}

-(void)onEnter
{
    
    float f3 = 15;
    float f2 = 8;
    float f1 = 6;
    CCSprite* structure = [CCSprite spriteWithFile:[structure_ spriteFile]];
    [self smartSet:structure PositionWithGrid:ccp(5,4)];
    [structure setAnchorPoint:ccp(0.5,0)];
    [info_base addChild:structure];
    
    CCLabelTTF* name = [CCLabelTTF labelWithString:[structure_ getName] fontName:@"Lato-Regular" fontSize:f3];
    [self smartSet:name PositionWithGrid:ccp(1,13)];
    [info_base addChild:name];
    
    
    CCLabelTTF* dps_title = [CCLabelTTF labelWithString:@"Damage per second" fontName:@"Lato-Regular" fontSize:f2];
    [self smartSet:dps_title PositionWithGrid:ccp(11,11)];
    [info_base addChild:dps_title];
    
    CCLabelTTF* dps = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[structure_ dps]] fontName:@"Lato-Regular" fontSize:f1];
    [self smartSet:dps PositionWithGrid:ccp(11,10)];
    [info_base addChild:dps];
    
    
    CCLabelTTF* aoe_title = [CCLabelTTF labelWithString:@"Area of effect" fontName:@"Lato-Regular" fontSize:f2];
    [self smartSet:aoe_title PositionWithGrid:ccp(11,8)];
    [info_base addChild:aoe_title];

    CCLabelTTF* aoe = [CCLabelTTF labelWithString:[structure_ aoe] fontName:@"Lato-Regular" fontSize:f1];
    [self smartSet:aoe PositionWithGrid:ccp(11,7)];
    [info_base addChild:aoe];
    
    
    CCLabelTTF* cost_title = [CCLabelTTF labelWithString:@"Cost to upgrade" fontName:@"Lato-Regular" fontSize:f2];
    [self smartSet:cost_title PositionWithGrid:ccp(11,5)];
    [info_base addChild:cost_title];
    
    CCLabelTTF* cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[structure_ cost]] fontName:@"Lato-Regular" fontSize:f1];
    [self smartSet:cost PositionWithGrid:ccp(11,4)];
    [info_base addChild:cost];
    
    
    CCLabelTTF* tips_title = [CCLabelTTF labelWithString:@"Tips" fontName:@"Lato-Regular" fontSize:f2];
    [self smartSet:tips_title PositionWithGrid:ccp(11,2)];
    [info_base addChild:tips_title];
    
}

-(void)smartSet:(id)sprite PositionWithGrid:(CGPoint)grid
{
    [sprite setAnchorPoint:ccp(0,0)];
    [sprite setPosition:ccp(horiGrid*grid.x,vertGrid*grid.y)];
}
@end
