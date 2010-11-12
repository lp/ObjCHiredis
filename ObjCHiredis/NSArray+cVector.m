//
//  NSArray+cVector.m
//  ObjCHiredis
//
//  Created by Louis-Philippe on 10-11-12.
//  Copyright 2010 Modul. All rights reserved.
//

#import "NSArray+cVector.h"

@implementation NSArray (NSArray_cVector)


- (const char**)cVector
{
	char ** vector = malloc(sizeof(char*) * [self count]);
	NSEnumerator * e = [self objectEnumerator];
	id o;
	while (o = [e nextObject]) {
		NSUInteger i = [self indexOfObject:o];
		vector[i] = (char*)[o UTF8String];
	}
	return (const char**)vector;
}

@end
