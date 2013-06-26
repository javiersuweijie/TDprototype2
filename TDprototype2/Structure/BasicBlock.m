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
    if ([super initWithFile:[NSString stringWithFormat:@"whitebox.png"]]) {
        [self setColor:ccc3(139, 188, 230)];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setColor:ccWHITE];
        [self setSize:CGSizeMake(1, 1)];
        [self setPosition:point];
        [self setName:@"basicbluebox"];
        [self setCanBeMoved:YES];
    }
    return self;

}

-(void)onEnter
{
    [super onEnter];
    for (NSValue *value in self.gridPosition) {
        NSLog(@"%@",NSStringFromCGPoint([value CGPointValue]));
    }
}
@end
