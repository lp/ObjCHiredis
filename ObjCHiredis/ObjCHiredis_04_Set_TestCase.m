//
//  ObjCHiredis_04_Set_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-22.
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

@interface ObjCHiredis_04_Set_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_04_Set_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis command:@"SADD BASKET PRUNE"];
	[redis command:@"SADD BASKET TOMATO"];
	[redis command:@"SADD BASKET ZUCHINI"];
	[redis retain];
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_SADD {
	id retVal = [redis command:@"SADD BASKET BANANA"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"SADD didn't return an NSNumber, got: %@", [[redis command:@"SADD BASKET BANANA"] class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"SADD didn't return success of adding member in Set, chould be 1, got: %d", [retVal integerValue]); 
}


@end
