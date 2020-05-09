/*
 * Copyright 2012-present Pixate, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  PXTextShadowStyler.m
//  Pixate
//
//  Created by Kevin Lindsey on 5/20/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import "PXTextShadowStyler.h"
#import <sys/utsname.h>

@implementation PXTextShadowStyler

#pragma mark - Static Methods

+ (PXTextShadowStyler *)sharedInstance
{
	static __strong PXTextShadowStyler *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedInstance = [[PXTextShadowStyler alloc] init];
	});

	return sharedInstance;
}

#pragma mark - Overrides

- (NSDictionary *)declarationHandlers
{
    static __strong NSDictionary *handlers = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        //disabilito le ombre su dispositivi iPhone5
        NSString *cssSelector = @"text-shadow";
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([code rangeOfString:@"iPhone5"].location != NSNotFound) {
            cssSelector = @"old-text-shadow";
        }
        
        handlers = @{
            cssSelector : ^(PXDeclaration *declaration, PXStylerContext *context) {
                context.textShadow = declaration.shadowValue;
            }
        };
    });

    return handlers;
}

@end