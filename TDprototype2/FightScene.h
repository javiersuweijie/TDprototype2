//
//  FightScene.h
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FightLayer.h"
@interface FightScene : CCScene {
    
}
@property FightLayer* fight_layer;

+(id)sceneWith:(id)boxLayer And:(id)filledList;
+(id)loadSceneWith:(id)boxLayer And:(id)filledList;
@end
