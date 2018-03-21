//
//  ImageDownload.h
//  MyApp3
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownload : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic) NSProgress *progress;
@property (nonatomic) NSUInteger taskIdentifier;

- (id)initWithURL:(NSURL *)url
         filename:(NSString * _Nullable)filename;

/**
 Update NSProgress

 @param totalBytesWritten Total number of bytes received thus far.
 @param totalBytesExpectedToWrite Total number of bytes expected (may be -1 if unknown).
 */

- (void)updateProgressForTotalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/**
 Start download of image.

 @param session The NSURLSession upon which this download will be processed.
 
 @note The `NSURLSession` is responsible for keeping track of which NSURLSessionTask is associated
    with which ImageDownload, and calling the relevant delegate method.
 */

- (void)startDownloadOnSession:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END

