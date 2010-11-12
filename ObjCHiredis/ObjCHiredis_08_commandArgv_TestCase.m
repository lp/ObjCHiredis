//
//  ObjCHiredis_08_commandArgv_TestCase.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-11-12.
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

@interface ObjCHiredis_08_commandArgv_TestCase : SenTestCase {
	ObjCHiredis * redis;
}

@end


@implementation ObjCHiredis_08_commandArgv_TestCase

- (void)setUp {
	redis = [ObjCHiredis redis];
	[redis retain];
	
}

- (void)tearDown {
	[redis command:@"FLUSHALL"];
	[redis release];
}

- (void)test_01_argv_string {
	id retVal = [redis commandArgv:[NSArray arrayWithObjects:
									@"SET", @"MYKEY", @"MYVALUE",
									nil]];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"commandArgv SET didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"OK"], @"commandArgv SET didn't return OK on success, got: %@", retVal);
	
	retVal = [redis commandArgv:[NSArray arrayWithObjects:
									@"GET", @"MYKEY",
									nil]];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"commandArgv SET didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"MYVALUE"], @"commandArgv SET didn't return OK on success, got: %@", retVal);
				 
}


@end
