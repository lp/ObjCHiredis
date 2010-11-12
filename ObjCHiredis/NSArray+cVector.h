//
//  NSArray+cVector.h
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-11-12.
//  Copyright 2010 Modul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_cVector)

- (const char**)cVector;

@end
