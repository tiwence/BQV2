//
//  FBSessionTokenStrategy.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 07/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "FBSessionTokenStrategy.h"

// Local cache - unique file info
static NSString* kFilename = @"TokenInfo.plist";

@interface FBSessionTokenStrategy ()
@property (nonatomic, strong) NSString *tokenFilePath;
- (NSString *) filePath;
@end

@implementation FBSessionTokenStrategy

- (id) init
{
    self = [super init];
    if (self) {
        _tokenFilePath = [self filePath];
    }
    return self;
}

- (NSString *) filePath {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void) writeData:(NSDictionary *) data {
    NSLog(@"File = %@ and Data = %@", self.tokenFilePath, data);
    BOOL success = [data writeToFile:self.tokenFilePath atomically:YES];
    if (!success) {
        NSLog(@"Error writing to file");
    }
}

- (NSDictionary *) readData {
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:self.tokenFilePath];
    NSLog(@"File = %@ and data = %@", self.tokenFilePath, data);
    return data;
}

- (void)cacheFBAccessTokenData:(FBAccessTokenData *)accessToken {
    NSDictionary *tokenInformation = [accessToken dictionary];
    [self writeData:tokenInformation];
}

- (FBAccessTokenData *)fetchFBAccessTokenData
{
    NSDictionary *tokenInformation = [self readData];
    if (nil == tokenInformation) {
        return nil;
    } else {
        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
    }
}

- (void)clearToken
{
    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
}


@end