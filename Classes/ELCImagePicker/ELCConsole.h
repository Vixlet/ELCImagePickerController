//
//  ELCConsole.h
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCConsole : NSObject
{
    NSMutableArray *selectedIndexes;
}
@property (nonatomic,assign) BOOL onOrder;
@property (nonatomic) NSUInteger maximumImagesCount;

+ (ELCConsole *)mainConsole;
- (void)addIndex:(NSUInteger)index;
- (void)removeIndex:(NSUInteger)index;
- (NSUInteger)currIndex;
- (NSUInteger)numOfSelectedElements;
- (void)removeAllIndex;

@end