//
//  ELCAssetCollectionPicker.h
//  Vixlet
//
//  Created by James Ajhar on 2/2/15.
//  Copyright (c) 2015 D9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"


@interface ELCAssetCollectionPicker : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ELCAssetDelegate>

@property (nonatomic, weak) id <ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;

// optional, can be used to filter the assets displayed
@property(nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (void)setVideoOverlayImage:(UIImage *)image;

@end
