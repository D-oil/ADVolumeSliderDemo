//
//  ViewController.m
//  ADVolumeSliderDemo
//
//  Created by andong on 16/3/22.
//  Copyright © 2016年 com.AnDong. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic ,strong)UIButton *volumeBtn;

@property (nonatomic, strong)UISlider *volumeSlider;
//是否静音
@property (nonatomic, assign)BOOL      isMute;

@property (nonatomic, assign)float     systemVolume;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //开启一个音频会话
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self createVolumeBtn];
    
    [self getSystemMPVolumeSlider];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // add event handler, for this example, it is `volumeChange:` method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
}

- (void)volumeChanged:(NSNotification *)notification
{
    if([[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"])
    {
        float volume = [[[notification userInfo]
                         objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
                        floatValue];
        if(volume == 0)
        {
            self.isMute = YES;
            [self changeButton:nil];
        }
        else
        {
            self.isMute = NO;
            [self changeButton:nil];
        }
    }
}

/**
 *  创建音量按钮
 */
- (void)createVolumeBtn
{
    self.volumeBtn = [[UIButton alloc]init];
    [self.volumeBtn setImage:[UIImage imageNamed:@"btn_novoice"] forState:UIControlStateNormal];
    [self.volumeBtn setImage:[UIImage imageNamed:@"btn_novoice-dis"] forState:UIControlStateHighlighted];
    [self.volumeBtn sizeToFit];
    [self.volumeBtn setCenter:self.view.center];
    [self.volumeBtn addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.volumeBtn];
}
/**
 *  获取系统音量条
 */
- (void)getSystemMPVolumeSlider
{
    //初始化音量条
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(20 ,100,self.view.frame.size.width-50, 50);
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:YES];
    [volumeView setHidden:NO];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];
    
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeSlider = (UISlider *)view;
            self.systemVolume = [[[self.volumeSlider valueForKey:@"volumeController"] valueForKey:@"volumeValue"] floatValue];
            [self.volumeSlider setValue:0 animated:NO];
            break;
        }
    }
    [self.volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.volumeSlider];
}
//改变button图片
- (void)changeButton:(UIButton *)btn
{
    if (self.isMute == YES)
    {
        [self.volumeBtn setImage:[UIImage imageNamed:@"btn_novoice"] forState:UIControlStateNormal];
        [self.volumeBtn setImage:[UIImage imageNamed:@"btn_novoice-dis"] forState:UIControlStateHighlighted];
        if (btn != nil) {
            self.systemVolume = [[[self.volumeSlider valueForKey:@"volumeController"] valueForKey:@"volumeValue"] floatValue];
            [self.volumeSlider setValue:0 animated:YES];
        }
        
    }
    else
    {
        [self.volumeBtn setImage:[UIImage imageNamed:@"btn_voice"] forState:UIControlStateNormal];
        [self.volumeBtn setImage:[UIImage imageNamed:@"btn_voice-pre"] forState:UIControlStateHighlighted];
        if (btn != nil) {
            [self.volumeSlider setValue:self.systemVolume animated:YES];
        }
    }
    self.isMute = !self.isMute;
    
}

@end
