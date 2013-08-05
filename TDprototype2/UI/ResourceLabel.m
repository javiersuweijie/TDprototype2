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
static CCSprite* goldIcon;

static int tech=10;
static CCLabelTTF* techLabel;
static CCSprite* techIcon;

static int life=20;
static CCSprite* lifeIcon;
static CCLabelTTF* lifeLabel;
static CCSprite* emptyLifeBar;
static CCSprite* filledLifeBar;

-(id)init
{
    if (self = [super init]) {
        CGSize winSize =[[CCDirector sharedDirector]winSize];
        
        [self setAnchorPoint:ccp(0,0)];
        
        goldIcon = [CCSprite spriteWithFile:@"treasure-icon.png"];
        [goldIcon setAnchorPoint:ccp(0,1)];
        [goldIcon setColor:ccc3(243, 156, 18)];
        goldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",gold] fontName:@"Lato-Regular" fontSize:18];
        [goldLabel setAnchorPoint:ccp(0,0.5)];
        [goldLabel setPosition:ccp([goldIcon contentSize].width,[goldIcon contentSize].height/2)];
        
        [goldIcon addChild:goldLabel];
        [goldIcon setPosition:ccp(winSize.width/40, winSize.height/30*29)];
        [self addChild:goldIcon];
        
        techIcon = [CCSprite spriteWithFile:@"technology-icon.png"];
        [techIcon setAnchorPoint:ccp(0,1)];
        [techIcon setColor:ccc3(52, 152, 219)];
        techLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",tech] fontName:@"Lato-Regular" fontSize:18];
        [techLabel setAnchorPoint:ccp(0,0.5)];
        [techLabel setPosition:ccp([techIcon contentSize].width,[techIcon contentSize].height/2)];
        
        [techIcon addChild:techLabel];
        [techIcon setPosition:ccp(winSize.width/40*8, winSize.height/30*29)];
        [self addChild:techIcon];
        
        
        lifeIcon = [CCSprite spriteWithFile:@"heart-icon.png"];
        [lifeIcon setAnchorPoint:ccp(0,1)];
        [lifeIcon setPosition:ccp(winSize.width/40*14, winSize.height/30*29)];
        [lifeIcon setColor:ccc3(231, 76, 60)];
        emptyLifeBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [emptyLifeBar setAnchorPoint:ccp(0,0.5)];
        [emptyLifeBar setPosition:ccp([lifeIcon contentSize].width,[lifeIcon contentSize].height/2)];
        [emptyLifeBar setColor:ccc3(52, 73, 94)];
        [lifeIcon addChild:emptyLifeBar];
        
        lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"^%d",life] fontName:@"Lato-Regular" fontSize:18];
        [lifeLabel setPosition:ccp([emptyLifeBar contentSize].width/2,[emptyLifeBar contentSize].height/2)];
        
        filledLifeBar = [CCSprite spriteWithFile:@"bar-01.png"];
        [filledLifeBar setAnchorPoint:ccp(0,0)];
        [filledLifeBar setColor:ccc3(231, 76, 60)];
        [emptyLifeBar addChild:filledLifeBar];
        [emptyLifeBar addChild:lifeLabel];
        [self addChild:lifeIcon];
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
    [goldLabel setString:[NSString stringWithFormat:@"%d",gold]];
}

+(BOOL)subtractGoldBy:(int)cost
{
    if (cost>gold) {
        return NO;
    }
    else {
        gold-=cost;
        [goldLabel setString:[NSString stringWithFormat:@"$%d",gold]];
        return YES;
    }
}
+(void)subtractTechBy:(int)cost
{
    tech-=cost;
    [techLabel setString:[NSString stringWithFormat:@"#%d",tech]];
}

+(void)subtractLifeBy:(int)cost
{
    life-=cost;
    [filledLifeBar setScaleX:(float)life/20.0];
    [lifeLabel setString:[NSString stringWithFormat:@"^%d",life]];
}

+(int)getGold
{
    return gold;
}
@end
