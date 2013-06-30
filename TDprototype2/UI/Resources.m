//
//  Resources.m
//  TDprototype2
//
//  Created by Javiersu on 30/6/13.
//
//

#import "Resources.h"

@implementation Resources
static int gold=1000;

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
}

+(BOOL)subtractGoldBy:(int)cost
{
    if (cost>gold) {
        return NO;
    }
    else {
        gold-=cost;
        return YES;
    }
}
+(int)getGold
{
    return gold;
}
@end
