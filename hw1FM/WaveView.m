//
//  WaveView.m
//  hw1Sine
//
//  Created by Mayank Sanganeria on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView

@synthesize dataSource = _dataSource;
@synthesize data = _data;


-(void)setData:(NSArray *)data {
    _data=data;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawWave
{
    NSArray *data = [self.dataSource getWaveData:self];
    int numOfPoints = [data count];
    if (numOfPoints > 0) {
        //start drawing
        CGContextRef context = UIGraphicsGetCurrentContext();    
        UIGraphicsPushContext(context);
        CGContextBeginPath(context);
        CGRect bounds = self.bounds;
        CGContextMoveToPoint(context,0,bounds.size.height/2+[[data objectAtIndex:0] floatValue]);        
            for (int i=1;i<numOfPoints;i++)
            {
                CGFloat x=bounds.size.width*(CGFloat)i/(CGFloat)numOfPoints,y=bounds.size.height/2+[[data objectAtIndex:i] floatValue];
                CGContextAddLineToPoint(context,x,y);
            }
        CGContextStrokePath(context);
        UIGraphicsPopContext();
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
- (void)drawRect:(CGRect)rect
{
    [self drawWave];
}


@end
