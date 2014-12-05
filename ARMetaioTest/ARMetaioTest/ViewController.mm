//
//  ViewController.m
//  ARMetaioTest
//
//  Created by 池田昂平 on 2014/10/20.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    //音の設定
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recogHover" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.recogSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    //glView生成 (metaio AR)
    self.glView = [[EAGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
    
    //ARView
    self.arview = [[ARView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.arview];
    
    [super viewDidLoad];
    
    m_metaioSDK->setTrackingEventCallbackReceivesAllChanges(true); //常時onTrackingEventを呼ぶ
    
    NSString *trackingid01 = [[NSBundle mainBundle] pathForResource:@"idmarkerConfig" ofType:@"zip"];
    if(trackingid01){
        bool success = m_metaioSDK->setTrackingConfiguration([trackingid01 UTF8String]);
        if(!success){
            NSLog(@"No success loading the trackingconfiguration");
        }
    }else{
        NSLog(@"No success loading the trackingconfiguration");
    }

}

- (void)onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues> &)poses{
    
    self.arview.capaRecog = NO;
    /*
    for(int i = 0; i < poses.size(); i++){
        NSLog(@"onTrackingEvent: quality:%f", poses[i].quality);
        
        if(poses[0].quality >= 0.5){
            self.arview.armarkerRecog = YES;
            [self.recogSound play];
            
            NSString *markerName = [NSString stringWithCString:poses[i].cosName.c_str() encoding:[NSString defaultCStringEncoding]];
            [self recogARID:markerName];
            
            
            self.arview.transComp = poses[i].translation;
            //3次元 → 2次元
            self.arview.arLocation = m_metaioSDK->getScreenCoordinatesFrom3DPosition(poses[i].coordinateSystemID, self.arview.transComp);
            //self.arview.arLocation = m_metaioSDK->getViewportCoordinatesFrom3DPosition(poses[i].coordinateSystemID, self.arview.transComp);
            
            NSLog(@"x座標: %f", self.arview.arLocation.x);
            NSLog(@"x座標: %f", self.arview.arLocation.y);
            //NSLog(@"x座標: %f", transComp.x);
            //NSLog(@"y座標: %f", transComp.y);
            //NSLog(@"cosName: %s", poses[i].cosName.c_str());
            [self.arview setNeedsDisplay];
        }else{
            self.arview.armarkerRecog = NO;
            [self.arview setNeedsDisplay];
        }
    }
     */
    
    if(poses[0].quality >= 0.5){
        self.arview.armarkerRecog = YES;
        [self.recogSound play];
        
        NSString *markerName = [NSString stringWithCString:poses[0].cosName.c_str() encoding:[NSString defaultCStringEncoding]];
        [self recogARID:markerName];
        
        
        self.arview.transComp = poses[0].translation;
        //3次元 → 2次元
        self.arview.arLocation = m_metaioSDK->getScreenCoordinatesFrom3DPosition(poses[0].coordinateSystemID, self.arview.transComp);
        //self.arview.arLocation = m_metaioSDK->getViewportCoordinatesFrom3DPosition(poses[i].coordinateSystemID, self.arview.transComp);
        
        //NSLog(@"x座標: %f", self.arview.arLocation.x);
        //NSLog(@"x座標: %f", self.arview.arLocation.y);
        
        //NSLog(@"x座標: %f", transComp.x);
        //NSLog(@"y座標: %f", transComp.y);
        
        NSLog(@"3次元 x座標:%f, y座標:%f", self.arview.transComp.x, self.arview.transComp.y); //3次元座標
        NSLog(@"2次元 x座標:%f, y座標:%f ", self.arview.arLocation.x, self.arview.arLocation.y); //2次元座標
        
        //NSLog(@"cosName: %s", poses[i].cosName.c_str());
        [self.arview setNeedsDisplay];
    }else{
        self.arview.armarkerRecog = NO;
        [self.arview setNeedsDisplay];
    }

    //NSLog(@"poses.size() = %lu", poses.size());
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//マーカー設定ファイル読み込み (AR)
- (void)loadConfig {
    NSString *trackingid01 = [[NSBundle mainBundle] pathForResource:@"idmarkerConfig" ofType:@"zip"];
    if(trackingid01){
        bool success = m_metaioSDK->setTrackingConfiguration([trackingid01 UTF8String]);
        if(!success){
            NSLog(@"No success loading the trackingconfiguration");
        }
    }else{
        NSLog(@"No success loading the trackingconfiguration");
    }
}

- (void)recogARID:(NSString *)markerName{
    
    /*
    if([markerName isEqualToString:@"patt01_1"]){
        self.arview.aridNum = 1;
    }else{
        self.arview.aridNum = 0;
        NSLog(@"maker name is %@", markerName);
    }
     */
    
    
    /*
    if([markerName isEqualToString:@"id01_1_1"]){
        self.arview.aridNum = 1;
    }else{
        self.arview.aridNum = 0;
        NSLog(@"maker name is %@", markerName);
    }
    */
    
    if([markerName isEqualToString:@"ID marker 1"]){
        self.arview.aridNum = 1;
    }else if([markerName isEqualToString:@"ID marker 2"]){
        self.arview.aridNum = 2;
    }else{
        self.arview.aridNum = 0;
        NSLog(@"maker name is %@", markerName);
    }
}

@end
