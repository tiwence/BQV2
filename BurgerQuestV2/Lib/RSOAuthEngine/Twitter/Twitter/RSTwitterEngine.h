//
//  RSTwitterEngine.h
//  RSOAuthEngine
//
//  Created by Rodrigo Sieiro on 12/8/11.
//  Copyright (c) 2011 Rodrigo Sieiro <rsieiro@sharpcube.com>. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "RSOAuthEngine.h"

@protocol RSTwitterEngineDelegate;

typedef void (^RSTwitterEngineForgetTokenCompletionBlock)(void);
typedef void (^RSTwitterEngineCompletionBlock)(NSError *error);
typedef void (^RSTwitterEngineStatusChangeHandler)(NSString *newStatus);

@interface RSTwitterEngine : RSOAuthEngine
{
    RSTwitterEngineCompletionBlock _oAuthCompletionBlock;
    NSString *_screenName;
}

@property (nonatomic, copy) RSTwitterEngineStatusChangeHandler statusChangeHandler;
@property (assign, nonatomic) UIViewController *presentingViewController;

@property (readonly) NSString *screenName;

- (id)initWithStatusChangedHandler:(RSTwitterEngineStatusChangeHandler) handler;
- (void)authenticateWithCompletionBlock:(RSTwitterEngineCompletionBlock)completionBlock;
- (void)forgetStoredToken;
- (void)forgetStoredTokenWithCompletionBlock:(RSTwitterEngineForgetTokenCompletionBlock)completionBlock;
- (void)sendTweet:(NSString *)tweet withCompletionBlock:(RSTwitterEngineCompletionBlock)completionBlock;

@end
