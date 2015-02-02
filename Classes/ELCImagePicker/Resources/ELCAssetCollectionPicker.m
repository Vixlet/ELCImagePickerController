//
//  ELCAssetCollectionPicker.m
//  Vixlet
//
//  Created by James Ajhar on 2/2/15.
//  Copyright (c) 2015 D9. All rights reserved.
//

#import "ELCAssetCollectionPicker.h"
#import "ELCAssetCollectionCell.h"
#import "ELCConsole.h"

@interface ELCAssetCollectionPicker ()

// Outlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

// Data
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;
@property (strong, nonatomic) UIImage *videoOverlayImage;

@end


@implementation ELCAssetCollectionPicker

- (id)init {
    self = [super init];
    
    UINib *nib = [VXResources nibWithNibName:@"ELCAssetCollectionPicker" fromBundleWithName:nil];
    self.view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self viewDidLoad];
    
    self.assets = [NSMutableArray new];
    self.selectedIndexPaths = [NSMutableArray new];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[VXResources nibWithNibName:@"ELCAssetCollectionCell" fromBundleWithName:nil]
          forCellWithReuseIdentifier:@"AssetCell"];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    [self.navigationItem setTitle:NSLocalizedString(@"Loading...", nil)];

    // Register for notifications when the photo library has changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePhotos) name:ALAssetsLibraryChangedNotification object:nil];
   
    [self.navigationItem setTitle:NSLocalizedString(@"Pick Photos", nil)];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ELCConsole mainConsole] removeAllIndex];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)setVideoOverlayImage:(UIImage *)image {
    _videoOverlayImage = image;
}

- (void)preparePhotos
{
    [self.assets removeAllObjects];
    
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result == nil) {
            [self performSelectorOnMainThread:@selector(reloadAssetsCollection) withObject:nil waitUntilDone:NO];
            return;
        }
        
        ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
        [elcAsset setParent:self];
        [self.assets addObject:elcAsset];
    }];
}

- (void)reloadAssetsCollection {
    [self.collectionView reloadData];
    
    // scroll to bottom
    NSInteger section = [self numberOfSectionsInCollectionView:self.collectionView] - 1;
    NSInteger row = [self collectionView:self.collectionView numberOfItemsInSection:section] - 1;
    
    if (section >= 0 && row >= 0) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                             inSection:section];
        
        [self.collectionView scrollToItemAtIndexPath:ip
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:NO];
    }
    
}

- (void)doneAction:(id)sender
{
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        [selectedAssetsImages addObject:[self.assets objectAtIndex:indexPath.row]];
    }
    
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    
    [self.selectedIndexPaths removeAllObjects];
    
    [self.parent selectedAssets:selectedAssetsImages];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset {
    BOOL shouldSelect;
   
    if(self.selectedIndexPaths.count < [[ELCConsole mainConsole] maximumImagesCount]) {
        shouldSelect = YES;
    }
    
    return shouldSelect;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

     
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"AssetCell";
    
    ELCAssetCollectionCell *cell = (ELCAssetCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setVideoOverlayImage:_videoOverlayImage];
    [cell setAsset:[self.assets objectAtIndex:indexPath.row]];
    
    if([self.selectedIndexPaths containsObject:indexPath]) {
        [cell setIsSelected:YES];
    } else {
        [cell setIsSelected:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCAssetCollectionCell *cell = (ELCAssetCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];

    
    if(!cell.selected) {
        // cell is not yet selected
        if([self shouldSelectAsset:cell.elcAsset]) {
            [self.selectedIndexPaths addObject:indexPath];
            [cell setIsSelected:YES];
        } else {
            NSString *photoString;
            
            if([[ELCConsole mainConsole] maximumImagesCount] != 1) {
                photoString = @"photos";
            } else {
                photoString = @"photo";
            }
            
            NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Only %d %@ please!", nil), [[ELCConsole mainConsole] maximumImagesCount], photoString];
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You may only select %d %@", nil), [[ELCConsole mainConsole] maximumImagesCount], photoString];
            
            [[[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok",@"Option for cancel the alert message")
                              otherButtonTitles:nil] show];
        }
        
    } else {
        // cell is already selected - deselect it
        [cell setIsSelected:NO];
        [self.selectedIndexPaths removeObject:indexPath];
        
    }

}


@end
