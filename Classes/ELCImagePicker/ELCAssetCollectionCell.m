//
//  ELCAssetCollectionCell.m
//  Vixlet
//
//  Created by James Ajhar on 2/2/15.
//  Copyright (c) 2015 D9. All rights reserved.
//

#import "ELCAssetCollectionCell.h"
#import "ELCAsset.h"

@interface ELCAssetCollectionCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *videoOverlayImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectionOverlayView;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImage *videoOverlayImage;

@end


@implementation ELCAssetCollectionCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(!self) {
        return nil;
    }
    
    return self;
}

- (void)setVideoOverlayImage:(UIImage *)image {
    _videoOverlayImage = image;
}

- (void)setAsset:(ELCAsset *)asset {
    _elcAsset = asset;
    [self setupView];
}

- (void)setIsSelected:(BOOL)selected {
    _isSelected = selected;
    self.selectionOverlayView.hidden = !selected;
}

- (void)setupView {
    if(_elcAsset == nil) {
        return;
    }
    
    [self.imageView setImage:[UIImage imageWithCGImage:_elcAsset.asset.thumbnail]];

    if([[self.elcAsset.asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:ALAssetTypeVideo]){
        self.videoOverlayImageView.image = _videoOverlayImage;
        self.videoOverlayImageView.hidden = NO;
    } else {
        self.videoOverlayImageView.hidden = YES;
    }
    
    self.selectionOverlayView.hidden = !_isSelected;
}

@end
