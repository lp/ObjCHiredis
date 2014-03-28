//
//  ObjCHiredis_02_String_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-20.
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


@interface ObjCHiredis_02_String_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_02_String_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
}

- (void)test_01_Set {
	STAssertTrue([[redis command:@"SET FOO BAR"] isEqualToString:@"OK"] , @"Couldn't SET, got %@", [redis command:@"SET FOO BAR"]);
}

- (void)test_02_Get {
	[redis command:@"SET FOO BAR"];
	STAssertTrue([[redis command:@"GET FOO"] isEqualToString:@"BAR"] , @"Couldn't GET, got %@", [redis command:@"GET BAR"]);
}



@end
