//
//  ViewController.m
//  Demo
//
//  Created by elvisgao on 2017/11/30.
//  Copyright © 2017年 com.tencent.elvisgao. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *videoName = @"noerrorvideo";
    NSString * videoName = @"errorvideo";
    NSString *path = [[NSBundle mainBundle] pathForResource:videoName ofType:@"mp4"];
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    NSArray* videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack* videoTrack = [videoTracks objectAtIndex:0];

    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInstruction setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoTrack.naturalSize;
    videoComp.frameDuration =  CMTimeMake(1, 25);
    videoComp.instructions = [NSArray arrayWithObject:instruction];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * videoCachePath = [[array firstObject] stringByAppendingPathComponent:@"video"];
    [[NSFileManager defaultManager]  createDirectoryAtPath:videoCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = [NSString stringWithFormat:@"trimVideoCopy_%zd.mp4",(unsigned int)(arc4random() % NSIntegerMax)];
    NSString *trimVideoPath = [videoCachePath stringByAppendingPathComponent:fileName];
    
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = [NSURL fileURLWithPath:trimVideoPath];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComp;
    
    NSLog(@"exportAsynchronouslyWithCompletionHandler begin");
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"exportAsynchronouslyWithCompletionHandler end");
        [[NSFileManager defaultManager] removeItemAtPath:trimVideoPath error:nil];
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed:
            {
                
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                
            }
                break;
            case AVAssetExportSessionStatusCancelled:
            {
            }
                break;
            default:
                break;
        }
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
