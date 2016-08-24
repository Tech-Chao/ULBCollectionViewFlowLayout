//
//  ULBCollectionViewFlowLayout.h
//  uliaobao
//
//  Created by FishYu on 16/8/24.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 扩展section的背景色
@protocol ULBCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section;
@end


@interface ULBCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
