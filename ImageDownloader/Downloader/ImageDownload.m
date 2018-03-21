//
//  ImageDownload.m
//  MyApp3
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

#import "ImageDownload.h"

static const long long kDefaultImageSize = 1000000; // what should we assume for totalBytesExpected if server doesn't provide it

@implementation ImageDownload

- (id)initWithURL:(NSURL *)url filename:(NSString *)filename {
    self = [super init];
    if (self) {
        _url = url;
        _progress = [NSProgress progressWithTotalUnitCount:kDefaultImageSize];
        _filename = filename ?: url.lastPathComponent;
    }
    return self;
}

- (void)startDownloadOnSession:(NSURLSession *)session {
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:self.url];
    self.taskIdentifier = task.taskIdentifier;
    [task resume];
}

- (void)updateProgressForTotalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    int64_t totalUnitCount = totalBytesExpectedToWrite;
    
    if (totalBytesExpectedToWrite < totalBytesWritten) {
        if (totalBytesWritten <= 0) {
            totalUnitCount = kDefaultImageSize;
        } else {
            double written = (double)totalBytesWritten;
            double percent = tanh(written / (double)kDefaultImageSize);
            totalUnitCount = written / percent;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.totalUnitCount = totalUnitCount;
        self.progress.completedUnitCount = totalBytesWritten;
    });
}

// MARK: - URLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    [self updateProgressForTotalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    self.progress.completedUnitCount = self.progress.totalUnitCount;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    NSURL *caches = [manager URLForDirectory:NSCachesDirectory
                                    inDomain:NSUserDomainMask
                           appropriateForURL:nil
                                      create:true
                                       error:&error];
    NSURL *folder = [caches URLByAppendingPathComponent:@"images"];
    [manager createDirectoryAtURL:folder withIntermediateDirectories:true attributes:nil error:nil];
    NSURL *destination = [folder URLByAppendingPathComponent:self.filename];
    NSLog(@"%@", destination);
    [manager removeItemAtURL:destination error:nil];
    BOOL success = [manager moveItemAtURL:location toURL:destination error:&error];
    if (!success) {
        // do something useful
        NSLog(@"%s: saving download failed: %@", __FUNCTION__, error);
    }
}

@end

