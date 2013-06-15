//
//  BasicBlock.m
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BasicBlock.h"


@implementation BasicBlock

-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"bluebox.png"]]) {
        [self setAnchorPoint:ccp(0.5,0)];
        [self setColor:ccWHITE];
        [self setPosition:point];
        [self setName:@"basicbluebox"];
        [self setCanBeMoved:YES];
    }
    return self;

}

@end
