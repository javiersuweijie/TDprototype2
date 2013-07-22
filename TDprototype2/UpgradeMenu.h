//
//  UpgradeMenu.h
//  TDprototype2
//
//  Created by Javiersu on 21/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CustomMenu.h"

@interface UpgradeMenu : CustomMenu {
    
}
- (id) initWithCurrent:(id)current andStrings:(NSString*)string1, ...;
@end
