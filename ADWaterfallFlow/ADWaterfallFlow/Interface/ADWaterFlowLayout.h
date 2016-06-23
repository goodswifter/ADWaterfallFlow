//
//  ADWaterFlowLayout.h
//  01-瀑布流
//
//  Created by zhongaidong on 16/5/7.
//  Copyright © 2016年 zhongaidong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADWaterFlowLayout;

@protocol ADWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout;
- (CGFloat)columnMarginInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout;
- (CGFloat)rowMarginInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout;
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout;
@end

@interface ADWaterFlowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<ADWaterFlowLayoutDelegate> delegate;
@end
