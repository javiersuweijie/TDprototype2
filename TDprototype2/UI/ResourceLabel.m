//
//  ResourceLabel.m
//  TDprototype2
//
//  Created by Javiersu on 30/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ResourceLabel.h"

@interface ResourceLabel () {
}

@end
@implementation ResourceLabel
static int gold=1000;
static CCLabelTTF* goldLabel;
static CCSprite* emptyGoldBar;
static CCSprite* filledGoldBar;

static int tech=10;
static CCLabelTTF* techLabel;
static CCSprite* emptyTechBar;
static CCSprite* filledTechBar;

-(id)init
{
    if (self = [super init]) {
        CGSize winSize =[[CCDirector sharedDirector]winSize];
        
        [self setAnchorPoint:ccp(0,0)];
        emptyGoldBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [emptyGoldBar setAnchorPoint:ccp(0,1)];
        [emptyGoldBar setColor:ccc3(52, 73, 94)];
        [emptyGoldBar.texture setAntiAliasTexParameters];
        [self addChild:emptyGoldBar];
        
        goldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%d",gold] fontName:@"Lato-Regular" fontSize:18];
        
        filledGoldBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [filledGoldBar setAnchorPoint:ccp(0,0)];
        [filledGoldBar setColor:ccc3(241, 196, 15)];
        [filledGoldBar.texture setAntiAliasTexParameters];
        [emptyGoldBar addChild:filledGoldBar];
        [emptyGoldBar addChild:goldLabel];
        
        [goldLabel setPosition:ccp([[goldLabel parent] contentSize].width/2,[[goldLabel parent] contentSize].height/2)];
        [emptyGoldBar setPosition:ccp(winSize.width/40, winSize.height/30*29)];
        
        emptyTechBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [emptyTechBar setAnchorPoint:ccp(0,1)];
        [emptyTechBar setColor:ccc3(52, 73, 94)];
        [self addChild:emptyTechBar];
        
        techLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"#%d",tech] fontName:@"Lato-Regular" fontSize:18];
        
        filledTechBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [filledTechBar setAnchorPoint:ccp(0,0)];
        [filledTechBar setColor:ccc3(26, 188, 156)];
        [emptyTechBar addChild:filledTechBar];
        [emptyTechBar addChild:techLabel];
        
        [techLabel setPosition:ccp([[techLabel parent] contentSize].width/2,[[techLabel parent] contentSize].height/2)];
        [emptyTechBar setPosition:ccp(winSize.width/40, winSize.height/30*27)];
    }
    return self;
}

+(BOOL)checkWallet:(int)cost
{
    if (cost>gold) {
        return NO;
    }
    else return YES;
}

+(void)addGoldBy:(int)addition
{
    gold+=addition;
    [filledGoldBar setScaleX:((float)gold/1000)];
    [goldLabel setString:[NSString stringWithFormat:@"$%d",gold]];
}

+(BOOL)subtractGoldBy:(int)cost
{
    [filledTechBar setScaleX:((float)tech/10)];
    [techLabel setString:[NSString stringWithFormat:@"#%d",tech]];
    if (cost>gold) {
        return NO;
    }
    else {
        gold-=cost;
        [filledGoldBar setScaleX:((float)gold/1000)];
        [goldLabel setString:[NSString stringWithFormat:@"$%d",gold]];
        return YES;
    }
}
+(void)subtractTechBy:(int)cost
{
    tech-=cost;
    [techLabel setString:[NSString stringWithFormat:@"#%d",tech]];
}

+(int)getGold
{
    return gold;
}
@end
