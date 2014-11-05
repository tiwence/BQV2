//
//  RSWebViewController.m
//  TwitterDemo
//
//  Created by Rodrigo Sieiro on 12/11/11.
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

#import "RSWebViewController.h"

// Private Methods
// this should be added before implementation 
@interface RSWebViewController (/*Private Methods*/)
@property (unsafe_unretained, nonatomic) NSURL *currentURL;
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)cancelAction:(id)sender;
@end

@implementation RSWebViewController

@synthesize currentURL = _currentURL;
@synthesize webView = _webView;
@synthesize activityIndicator = _activityIndicator;
@synthesize callbackURL = _callbackURL;

@synthesize authenticationCompletedHandler = _authenticationCompletedHandler;
@synthesize authenticationCanceledHandler = _authenticationCanceledHandler;

#pragma mark - Initialization

- (id)initWithURL:(NSURL *)url
{
  self = [self initWithNibName:@"RSWebViewController" bundle:nil];
  
  if (self) {
    self.currentURL = url;
  }
  
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.webView.scalesPageToFit = YES;
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.currentURL]];
}

- (void)viewDidUnload
{
  [self setWebView:nil];
  [self setActivityIndicator:nil];
  
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([request.URL.scheme isEqualToString:@"burgerquestapp"]) {
    
    if (self.activityIndicator) [self.activityIndicator stopAnimating];
    
    if ([request.URL.query hasPrefix:@"denied"]) {
      self.authenticationCanceledHandler();
    } else {
      self.authenticationCompletedHandler(request.URL);
    }    
    return NO;
  } else {
    return YES;
  }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  if (self.activityIndicator) [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  if (self.activityIndicator) [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  if (self.activityIndicator) [self.activityIndicator stopAnimating];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[error localizedDescription]
                                                 delegate:nil
                                        cancelButtonTitle:@"Dismiss"
                                        otherButtonTitles:nil];
  [alert show];
}

#pragma mark - Custom Methods

- (IBAction)cancelAction:(id)sender
{
  self.authenticationCanceledHandler();
}

@end
