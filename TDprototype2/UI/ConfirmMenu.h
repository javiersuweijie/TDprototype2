//
//  ConfirmMenu.h
//  TDprototype2
//
//  Created by Javiersu on 17/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CustomMenu.h"
#import "Structure.h"
@interface ConfirmMenu : CustomMenu {
    
}
@property Structure* structure;
@property Structure* current;
// confirmmenu is tagged to 2
-(void)openWithStructure:(Structure*)structure;
-(void)openWithStructure:(Structure *)structure andCurrent:(Structure *)currentStruct;
@end
