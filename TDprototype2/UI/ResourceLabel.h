//
//  ResourceLabel.h
//  TDprototype2
//
//  Created by Javiersu on 30/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ResourceLabel : CCNode {
    
}

@property int gold;
+(BOOL)checkWallet:(int)cost;
+(BOOL)subtractGoldBy:(int)cost;
+(void)addGoldBy:(int)addition;
+(int)getGold;
@end
