//
//  BasicBlock.m
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BasicBlock.h"


@implementation BasicBlock
static int cost = 0;

-(id)initWithPosition:(CGPoint)point
{

    if ([super initWithFile:[NSString stringWithFormat:@"psuedoisobox.png"]]) {
        [self setColor:ccc3(189, 195, 199)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(1, 1)];
        [self setCost:cost];
        [self setPosition:point];
        [self setName:@"BasicBlock"];
        [self setCanBeMoved:YES];
    }
    return self;

}

-(void)onEnter
{
    [super onEnter];
    for (NSValue *value in self.gridPosition) {
//        NSLog(@"%@",NSStringFromCGPoint([value CGPointValue]));
    }
}

@end
