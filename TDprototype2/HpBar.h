//
//  HpBar.h
//  TDprototype2
//
//  Created by Javiersu on 19/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Unit.h"
@interface HpBar : CCLayer {
    
}
@property int totalHp;
@property int currentHp;
@property (assign,nonatomic) Unit* p;
-(id)initWithChar:(Unit*)p;
@end
