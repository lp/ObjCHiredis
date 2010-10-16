//
//  ObjCHiredis_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-15.
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


@interface ObjCHiredis_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
}

- (void)tearDown {
	[redis release];
}

- (void) test_01_Math {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );    
}

- (void)test_02_Init {
	STAssertNotNil(redis, @"Couldn't init... ");
}

- (void)test_03_String {
	STAssertTrue([[redis command:@"SET FOO BAR"] isEqualToString:@"OK"] , @"Couldn't SET, got %@", [redis command:@"SET FOO BAR"]);
	STAssertTrue([[redis command:@"GET BAR"] isEqualToString:@"BAR"] , @"Couldn't GET, got %@", [redis command:@"GET BAR"]);
}

@end
