//
//  ELCConsole.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCConsole.h"

static ELCConsole *_mainconsole;

@implementation ELCConsole

+ (ELCConsole *)mainConsole
{
    if (!_mainconsole) {
        _mainconsole = [[ELCConsole alloc] init];
    }
    return _mainconsole;
}

- (id)init
{
    self = [super init];
    if (self) {
        selectedIndexes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    selectedIndexes = nil;
    _mainconsole = nil;
}

- (void)addIndex:(NSUInteger)index
{
    if (![selectedIndexes containsObject:@(index)]) {
        [selectedIndexes addObject:@(index)];
    }
}

- (void)removeIndex:(NSUInteger)index
{
    [selectedIndexes removeObject:@(index)];
}

- (void)removeAllIndex
{
    [selectedIndexes removeAllObjects];
}

- (NSUInteger)currIndex
{
    [selectedIndexes sortUsingSelector:@selector(compare:)];
    
    for (int i = 0; i < [selectedIndexes count]; i++) {
        int c = [[selectedIndexes objectAtIndex:i] intValue];
        if (c != i) {
            return i;
        }
    }
    return [selectedIndexes count];
}

- (NSUInteger)numOfSelectedElements {
    
    return [selectedIndexes count];
}


@end
