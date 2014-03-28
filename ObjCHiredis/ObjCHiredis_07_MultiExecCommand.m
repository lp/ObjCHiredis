//
//  ObjCHiredis_07_MultiExecCommand.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-10-28.
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


@interface ObjCHiredis_07_MultiExecCommand : SenTestCase {
	ObjCHiredis * redis;
}

@end

@implementation ObjCHiredis_07_MultiExecCommand

- (void)setUp {
	redis = [ObjCHiredis redis:@"127.0.0.1" on:[NSNumber numberWithInt:6379] db:[NSNumber numberWithInt:101]];
}

- (void)tearDown {
	[redis command:@"FLUSHDB"];
	[redis close];
}

- (void)test_01_MULTI {
	id retVal = [redis command:@"MULTI"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"MULTI didn't return an NSString");
	STAssertTrue([retVal isEqualToString:@"OK"], @"MULTI didn't return OK, got: %@", retVal);
}

- (void)test_02_EXEC {
	id retVal = [redis command:@"EXEC"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"EXEC didn't return an NSString with error message on failure, got: %@", retVal);
	
	[redis command:@"MULTI"];
	retVal = [redis command:@"EXEC"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"EXEC didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 0, @"EXEC didn't return an empty array when called with no commands, got: %d", [retVal count]);
}

- (void)test_03_COMMAND {
	[redis command:@"MULTI"];
	id retVal = [redis command:@"RPUSH BASKET POTATO"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"COMMAND in MULTI didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"QUEUED"], @"COMMAND in MULTI didn't return QUEUD, got: %@", retVal);
	
	retVal = [redis command:@"LRANGE BASKET 0 1"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"COMMAND in MULTI didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"QUEUED"], @"COMMAND in MULTI didn't return QUEUED, got: %@", retVal);
	
	retVal = [redis command:@"EXEC"];
	STAssertTrue([retVal isKindOfClass:[NSArray class]], @"EXEC didn't return an NSArray, got: %@", [retVal class]);
	STAssertTrue([retVal count] == 2, @"EXEC didn't return an array with results of right size, should be 2, got: %d", [retVal count]);
	
	STAssertTrue([[retVal objectAtIndex:0] isKindOfClass:[NSNumber class]], @"EXEC didn't return the result properly");
	STAssertTrue([[retVal objectAtIndex:0] isEqualToNumber:[NSNumber numberWithInt:1]], @"EXEC didn't return the result properly"); 
	
	STAssertTrue([[retVal objectAtIndex:1] isKindOfClass:[NSArray class]], @"EXEC didn't return the result properly");
	STAssertTrue([[retVal objectAtIndex:1] count] == 1, @"EXEC didn't return the result properly, should be 1, got %d", [[retVal objectAtIndex:1] count]);
	STAssertTrue([[[retVal objectAtIndex:1] objectAtIndex:0] isKindOfClass:[NSString class]], @"EXEC didn't return the result properly");
	STAssertTrue([[[retVal objectAtIndex:1] objectAtIndex:0] isEqualToString:@"POTATO"], @"EXEC didn't return the result properly");
}

- (void)test_04_DISCARD {
	[redis command:@"MULTI"];
	
	id retVal = [redis command:@"RPUSH BASKET PEACH"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"COMMAND in MULTI didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"QUEUED"], @"COMMAND in MULTI didn't return QUEUD, got: %@", retVal);
	
	retVal = [redis command:@"DISCARD"];
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"DISCARD didn't return an NSString, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToString:@"OK"], @"DISCARD didn't return OK, got: %@", retVal);
	
	retVal = [redis command:@"RPUSH BASKET CUCUMBER"];
	STAssertTrue([retVal isKindOfClass:[NSNumber class]], @"COMMAND after DISCARD didn't return an NSNumber, got: %@", [retVal class]);
	STAssertTrue([retVal isEqualToNumber:[NSNumber numberWithInt:1]], @"COMMAND after DISCARD didn't return regular value, should be 1, got: %d", [retVal integerValue]);
}

//- (void)test_05_WATCH {
//	[redis command:@"SET MYKEY MYVALUE"];
//	
//	id retVal = [redis command:@"WATCH MYKEY"];
//	STAssertTrue([retVal isKindOfClass:[NSString class]], @"WATCH didn't return an NSString, got: %@", [retVal class]);
//	STAssertTrue([retVal isEqualToString:@"OK"], @"WATCH didn't return OK, got: %@", retVal);
//}

@end
