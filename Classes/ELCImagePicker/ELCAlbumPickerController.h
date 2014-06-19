//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//
//  Modified by gp

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"

@interface ELCAlbumPickerController : UITableViewController <ELCAssetSelectionDelegate>

@property (nonatomic, weak) id<ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;

// optional, can be used to filter the assets displayed
@property (nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;
// doesn't update image for already presented controllers
- (void)setSelectionOverlayImage:(UIImage *)image;

@end
