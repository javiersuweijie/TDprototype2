//
//  Structure.h
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Structure : CCSprite <UIGestureRecognizerDelegate> {
    
}
@property (nonatomic) CGPoint gridPosition;
-(void)setName:(NSString*)n;
-(void)setCanBeMoved:(BOOL)b;
@end
