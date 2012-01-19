//
//  hw1FMViewController.h
//  hw1FM
//
//  Created by Mayank Sanganeria on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"

@interface hw1FMViewController : UIViewController <WaveViewProtocol>
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UISlider *indexSlider;
@property (weak, nonatomic) IBOutlet WaveView *waveView;



- (IBAction)continuousToggle:(id)sender;
- (IBAction)indexSliderChange:(id)sender;
- (IBAction)triggerNote:(id)sender;

@end
