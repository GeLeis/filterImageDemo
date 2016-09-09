//
//  GPUImageBeautifyFilter.h
//  BeautifyFaceDemo
//
//  Created by guikz on 16/4/28.
//  Copyright © 2016年 guikz. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup {
	
	
	
	
}
@property (nonatomic,strong)GPUImageBilateralFilter *bilateralFilter;//双边滤波;
@property (nonatomic,strong) GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
@property (nonatomic,strong) GPUImageCombinationFilter *combinationFilter;
@property (nonatomic,strong) GPUImageHSBFilter *hsbFilter;
@end
