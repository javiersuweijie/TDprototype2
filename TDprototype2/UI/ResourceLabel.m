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

-(id)init
{
    if (self = [super init]) {
        goldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%d",gold] fontName:@"Helvetica" fontSize:30];
        [self addChild:goldLabel];
        [self setPosition:ccp([[CCDirector sharedDirector]winSize].width/2, 300)];
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
    [goldLabel setString:[NSString stringWithFormat:@"$%d",gold]];
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
+(int)getGold
{
    return gold;
}
@end
