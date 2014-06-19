//
//  AssetCell.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//
//  Modified by gp

#import <UIKit/UIKit.h>


@interface ELCAssetCell : UITableViewCell

- (void)setAssets:(NSArray *)assets;
- (void)setSelectionOverlayImage:(UIImage *)image;

@end
