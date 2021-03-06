#import "NSFileManager+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSFileManager (Utils)

- (NSString *)documentPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return pathArray[0];
}

- (NSString *)libraryPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return pathArray[0];
}

- (NSString *)cachesPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return pathArray[0];
}

- (NSString *)md5:(NSString *)path {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) {
        return nil;
    }

    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    NSData *filedata;

    do {
        filedata = [handle readDataOfLength:1024];
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
    } while ([filedata length]);

    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];

    NSMutableString *hash = [NSMutableString string];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }

    return [hash lowercaseString];
}

@end
