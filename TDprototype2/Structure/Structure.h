//
//  Structure.h
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "Unit.h"
#import "ResourceLabel.h"
@interface Structure : CCSprite <UIGestureRecognizerDelegate> {
    
}

@property (nonatomic,strong) NSArray* gridPosition;
@property int cost;
@property NSString* spriteFile;
@property CGPoint tempPosition;

-(void)setName:(NSString*)n;
-(void)setCanBeMoved:(BOOL)b;
-(void)setSize:(CGSize)size;
-(NSString*)getName;
-(void)unSelect;
+(int)cost;
-(int)dps;
-(NSString*)aoe;
+(BOOL)isSelectedGlobally;
@end
