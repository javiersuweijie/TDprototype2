//
//  WorldTree.m
//  TDprototype2
//
//  Created by Javiersu on 10/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WorldTree.h"


@implementation WorldTree


-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"worldtree.png"]]) {
        [self setAnchorPoint:ccp(0.5,0)];
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
    [parent_ reorderChild:self z:-self.position.y];
}

@end
