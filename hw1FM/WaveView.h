//
//  WaveView.h
//  hw1Sine
//
//  Created by Mayank Sanganeria on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaveView;

@protocol WaveViewProtocol
- (NSArray *)getWaveData:(WaveView *)self;
@end

@interface WaveView : UIView

@property (weak,nonatomic) id <WaveViewProtocol> dataSource;
@property (weak, nonatomic) NSArray *data;

-(void)drawWave;

@end