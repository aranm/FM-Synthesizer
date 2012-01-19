//
//  hw1FMViewController.m
//  hw1FM
//
//  Created by Mayank Sanganeria on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "hw1FMViewController.h"

#import "mo_audio.h"
#import "mo_touch.h"
#import "mo_accel.h"
#import "Envelope.h"

#define SRATE 44100
#define FRAMESIZE 128
#define NUMCHANNELS 2
#define TWO_PI 6.28318531


stk::Envelope *g_envelope;

double g_fc = 440.0;
double g_fOffset = 0.0;

float g_bufferdata[512];

float s = 1.0/SRATE*TWO_PI;
bool g_continous;
float g_f_c_base = 440;
float g_f_c = 440;
float g_index = 200;
float g_f_m=500;
float g_f_m_base=500;
float g_phi_c;
float g_phi_m;
float g_gain = 0.9;
float g_alpha = 1.0;

void synthesize( SAMPLE * buffer, long bufferSize )
{
	g_gain = g_gain * g_alpha;	
    for( long i = 0; i < bufferSize; i++ )
    {
        if (g_continous) {
    
            g_phi_m += g_f_m * s;
            g_phi_c += ((g_f_c + g_index * sin(g_phi_m))*s);
            float val = g_gain * sin(g_phi_c);
            g_envelope->setTarget(val);
        }
        else
            g_envelope->setTarget(0);

        buffer[2*i] = buffer[2*i+1] = g_envelope->tick();;
        g_bufferdata[i] = 3*buffer[2*i];
    }
}
void accelCallback( double x, double y, double z, void * data )
{
    // NSLog(@"Accel!");        
    g_f_c = g_f_c_base + x * 400;
    g_f_m = g_f_m_base + y*50;

    WaveView *wv = (__bridge WaveView *)data;
    [wv setNeedsDisplay];
}

// the audio callback
void audioCallback( Float32 * buffer, UInt32 frameSize, void * userData )
{
    synthesize(buffer,frameSize);
}

void touchCallback( NSSet * touches, UIView * view, const std::vector<MoTouchTrack> & touchPts, void * data)
{
    // NSLog(@"Touch!!!");        
    UIView * vview = (__bridge UIView *)data;
    long count = [touches count];
    float x_diff=0,y_diff=0;
    // If there's one touch
    if(count==2)
    {
        for( UITouch * touch in touches)
        {
            
            CGPoint point = [touch locationInView:vview];
            g_fOffset = point.x;
            x_diff = -x_diff+point.x;
            y_diff = -y_diff+point.y;
        }
        float dist = powf(x_diff*x_diff + y_diff*y_diff,0.5);
        NSLog(@"%f", dist);
        
    }
}




@implementation hw1FMViewController
@synthesize toggleSwitch;
@synthesize indexSlider;
@synthesize waveView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // log
    NSLog( @"starting real-time audio..." );
    
    
    g_envelope = new stk::Envelope;
    g_envelope->setTime(0.05);
    g_envelope->setValue(1.0);
    // init the audio layer
    bool result = MoAudio::init( SRATE, 64, 2 );
    if( !result )
    {
        // something went wrong
        NSLog( @"cannot initialize real-time audio!" );
        // bail out
        return;
    }
    // start the audio layer, registering a callback method
    result = MoAudio::start( audioCallback, NULL );
    if( !result )
    {
        // something went wrong
        NSLog( @"cannot start real-time audio!" );
        // bail out
        return;
    }
    //self.waveView.dataSource = self;
    MoAccel::addCallback( accelCallback, (__bridge void*)self.waveView);
    
    MoTouch::addCallback( touchCallback, NULL);
    self.waveView.dataSource = self;
    
}


- (void)viewDidUnload
{
    [self setToggleSwitch:nil];
    [self setIndexSlider:nil];
    [self setWaveView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)continuousToggle:(id)sender {
    if ( toggleSwitch.on ) {
		g_gain = .9;
	}
    g_continous = toggleSwitch.on;
}

- (IBAction)indexSliderChange:(id)sender {
    g_index = 700*[indexSlider value];
}


- (IBAction)triggerNote:(id)sender {
 	g_gain = .9;   
}

-(NSArray *)getWaveData:(WaveView *)wavev {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:128];
    for (int i=0;i<128;i++)
    {
        [array addObject:[NSNumber numberWithFloat:g_bufferdata[i]]];
    }
    return array;
}

@end
