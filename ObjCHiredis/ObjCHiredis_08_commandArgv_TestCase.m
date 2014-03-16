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
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
	
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
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

- (void)test_02_argv_loadup {
	NSString * bigString = @"lambda {|params| puts 'Starting lambda'; params.each {|item| puts \"there is #{item}\"}}";
	id retVal = [redis commandArgv:[NSArray arrayWithObjects:
									@"HSET", @"lambdas", @"unused", bigString,
									nil]];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"commandArgv HSET didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"commandArgv HSET didn't return 1 on success, got: %d", [retVal integerValue]);
	
	retVal = [redis commandArgv:[NSArray arrayWithObjects:
								 @"HGET", @"lambdas", @"unused",
								 nil]];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"commandArgv HGET didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:bigString], @"commandArgv HGET didn't return the right value, should be: %@, got: %@", bigString, retVal);
}


@end
