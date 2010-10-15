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
	
}

@end

@implementation ObjCHiredis_TestCase

- (void) test_01_Math {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );    
}

@end
