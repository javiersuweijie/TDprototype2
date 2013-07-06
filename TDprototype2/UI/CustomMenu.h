//
//  CustomMenu.h
//  TDprototype2
//
//  Created by Javiersu on 6/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CustomMenu : CCNode {
    
}
@property BOOL isSelected;

-(id) initWithArray:(NSArray *)arrayOfItems;
-(void)arrangeCircle;
-(void)keepCircle;
@end
