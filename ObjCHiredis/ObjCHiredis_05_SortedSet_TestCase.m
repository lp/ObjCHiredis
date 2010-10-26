//
//  ObjCHiredis_05_SortedSet_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-26.
//  Copyright 2010 Modul. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>

#ifdef IOS
#import "ObjCHiredis.h"
#endif

#ifndef IOS
#import "ObjCHiredis/ObjCHiredis.h"
#endif

@interface ObjCHiredis_05_SortedSet_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end


@implementation ObjCHiredis_05_SortedSet_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}


@end
