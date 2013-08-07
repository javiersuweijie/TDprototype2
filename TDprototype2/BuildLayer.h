//
//  BuildLayer.h
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BuildLayer : CCLayer <UIGestureRecognizerDelegate>{
    
}
@property id unitAndBoxLayer;
@property NSMutableArray* filledList;

-(BOOL)isValid:(CGPoint)point;
-(BOOL)isValidGrid:(CGPoint)grid;
-(NSArray*)walkableAdjGrid:(CGPoint)grid;

-(id)initFirst;
-(id)initWith:(id)boxLayer and:(id)filled_list;
-(id)placeTower:(NSString*)tower;
-(void)exportData;
-(void)loadData;
-(void)loadUnit;

-(NSString*)fightOrBuild;
-(NSMutableArray*)filledList;

-(float)getScale;
@end
