//
//  ViewController.m
//  BeautifyFaceDemo
//
//  Created by guikz on 16/4/27.
//  Copyright © 2016年 guikz. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
#import <Masonry/Masonry.h>
#import <Photos/Photos.h>
@interface ViewController ()

@property (nonatomic, strong) GPUImageStillCamera *videoCamera;//视频处理用GPUImageVideoCamera
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *beautifyButton;
@property (nonatomic,strong) UIButton *captureBtn;
@property (nonatomic,strong) AVCaptureStillImageOutput *stillImageOutPut;
@property (nonatomic,strong) GPUImageBeautifyFilter *beautifyFilter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterView.center = self.view.center;
	
    [self.view addSubview:self.filterView];
    [self.videoCamera addTarget:self.filterView];
	
    [self.videoCamera startCameraCapture];
    
    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautifyButton.backgroundColor = [UIColor whiteColor];
    [self.beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautifyButton];
    [self.beautifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
    }];
	
	self.captureBtn = [[UIButton alloc] init];
	[self.captureBtn setBackgroundColor:[UIColor greenColor]];
	[self.captureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.captureBtn setTitle:@"拍照" forState:UIControlStateNormal];
	[self.captureBtn addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.captureBtn];
	[self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-20);
		make.left.equalTo(self.beautifyButton.mas_right).offset(20);
	}];
	
	_beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
}

-(void)capturePhoto:(id)sender{
	[self.videoCamera capturePhotoAsJPEGProcessedUpToFilter:self.beautifyFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
		UIImage *image = [UIImage imageWithData:processedJPEG];
		if (image) {
			PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
			if (authorStatus == PHAuthorizationStatusRestricted || authorStatus == PHAuthorizationStatusDenied) {
				return ;
			}
			PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
			[library performChanges:^{
				[PHAssetChangeRequest creationRequestForAssetFromImage:image];
			} completionHandler:^(BOOL success, NSError * _Nullable error) {

			}];
			
		}
	}];
	
}

- (void)beautify {
	
	
	[self.videoCamera removeAllTargets];
	[_beautifyFilter removeAllTargets];
	[self.videoCamera addTarget:_beautifyFilter];
	[_beautifyFilter addTarget:self.filterView];
	
	
    if (self.beautifyButton.selected) {
        self.beautifyButton.selected = NO;
		self.beautifyFilter.bilateralFilter.distanceNormalizationFactor = NSNotFound;
		[self.beautifyFilter.hsbFilter reset];//亮度
    }
    else {
        self.beautifyButton.selected = YES;
		self.beautifyFilter.bilateralFilter.distanceNormalizationFactor = 5;
		[self.beautifyFilter.hsbFilter adjustBrightness:1.1];//亮度
		[self.beautifyFilter.hsbFilter adjustSaturation:1.1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
