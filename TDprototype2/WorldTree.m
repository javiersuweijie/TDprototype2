//
//  WorldTree.m
//  TDprototype2
//
//  Created by Javiersu on 10/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WorldTree.h"
#import "IsometricOperator.h"

@implementation WorldTree


-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"worldtree.png"]]) {
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(2.0, 2.0)];
        [self setPosition:point];
        [self setName:@"worldtree"];
        [self setScale:2];
        [self setCanBeMoved:NO];

    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    for (NSValue *value in self.gridPosition) {
        NSLog(@"%@",NSStringFromCGPoint([value CGPointValue]));
    }
    [parent_ reorderChild:self z:-self.position.y];
    
//    for (NSValue* value in self.gridPosition) {
//        CCSprite* sprite = [[CCSprite alloc]initWithFile:@"redbox.png"];
//        sprite.anchorPoint = ccp(0.5,0);
//        sprite.position = [IsometricOperator gridToCoord:[value CGPointValue]];
//        [parent_ addChild:sprite];
//    }
}

@end
