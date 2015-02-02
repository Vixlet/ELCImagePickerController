//
//  ELCAssetCollectionCell.h
//  Vixlet
//
//  Created by James Ajhar on 2/2/15.
//  Copyright (c) 2015 D9. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCAsset;

@interface ELCAssetCollectionCell : UICollectionViewCell

@property (strong, nonatomic) ELCAsset *elcAsset;

- (void)setVideoOverlayImage:(UIImage *)image;
- (void)setAsset:(ELCAsset *)asset;
- (void)setIsSelected:(BOOL)selected;

@end
