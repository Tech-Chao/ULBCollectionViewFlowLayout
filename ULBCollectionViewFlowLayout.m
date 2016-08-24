//
//  ULBCollectionViewFlowLayout.m
//  uliaobao
//
//  Created by FishYu on 16/8/24.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ULBCollectionViewFlowLayout.h"


static NSString *const ULBCollectionViewSectionColor = @"com.ulb.ULBCollectionElementKindSectionColor";


@interface ULBCollectionViewLayoutAttributes  : UICollectionViewLayoutAttributes
// 背景色
@property (nonatomic, strong) UIColor *backgroudColor;

@end

@implementation ULBCollectionViewLayoutAttributes

@end

@interface ULBCollectionReusableView : UICollectionReusableView

@end


@implementation ULBCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    ULBCollectionViewLayoutAttributes *attr = (ULBCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attr.backgroudColor;
}

@end



@interface ULBCollectionViewFlowLayout  ()

@property (nonatomic, strong) UIColor *sectonColor;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end


@implementation ULBCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    id<ULBCollectionViewDelegateFlowLayout> delegate  = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:colorForSectionAtIndex:)]) {
    }else{
        return ;
    }
    
    //1.初始化
    [self registerClass:[ULBCollectionReusableView class] forDecorationViewOfKind:ULBCollectionViewSectionColor];
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section =0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:(numberOfItems - 1) inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
                if (!UIEdgeInsetsEqualToEdgeInsets(inset, sectionInset)) {
                    sectionInset = inset;
                }
            }
            
            
            CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }else{
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
            }
            
            //2. 定义
            ULBCollectionViewLayoutAttributes *attr = [ULBCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:ULBCollectionViewSectionColor withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attr.frame = sectionFrame;
            attr.zIndex = -1;
            attr.backgroudColor = [delegate collectionView:self.collectionView layout:self colorForSectionAtIndex:section];
            [self.decorationViewAttrs addObject:attr];
        }else{
            continue ;
        }
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray * attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return [attrs copy];
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end
