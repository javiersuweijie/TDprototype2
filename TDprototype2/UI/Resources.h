//
//  Resources.h
//  TDprototype2
//
//  Created by Javiersu on 30/6/13.
//
//

#import <Foundation/Foundation.h>

@interface Resources : NSObject
+(BOOL)checkWallet:(int)cost;
+(BOOL)subtractGoldBy:(int)cost;
+(void)addGoldBy:(int)addition;
+(int)getGold;
@end
