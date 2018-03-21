//
//  Downloader.m
//  ImageDownloader
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

#import "Downloader.h"
#import "ImageDownload.h"

@interface Downloader () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation Downloader

+ (Downloader *)sharedDownloader {
    static Downloader *sharedDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDownloader = [[self alloc] init];
    });
    return sharedDownloader;
}

- (id)init {
    if ((self = [super init])) {
        _imageDownloads = [[NSMutableArray alloc] init];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:nil];
    }
    return self;
}

- (ImageDownload *)startDownload:(NSURL *)url filename:(NSString *)filename {
    ImageDownload *imageDownload = [[ImageDownload alloc] initWithURL:url
                                                             filename:filename];
    [self.imageDownloads addObject:imageDownload];
    [imageDownload startDownloadOnSession:self.session];
    return imageDownload;
}

/**
 Identify which download in our array is associated with a particular taskIdentifier.
 
 @param taskIdentifier The URLSession task identifier.
 @return The ImageDownload associated with that task identifier. If not found, return nil.
 */

- (ImageDownload *)imageDownloadWithTaskIdentifier:(NSUInteger)taskIdentifier {
    NSUInteger index = [self.imageDownloads indexOfObjectPassingTest:^BOOL(ImageDownload * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.taskIdentifier == taskIdentifier;
    }];
    
    return index == NSNotFound ? nil : self.imageDownloads[index];
}

// MARK: - URLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    ImageDownload *imageDownload = [self imageDownloadWithTaskIdentifier:downloadTask.taskIdentifier];
    NSAssert(imageDownload, @"did not find imageDownload for image!");
    
    [imageDownload URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    ImageDownload *imageDownload = [self imageDownloadWithTaskIdentifier:downloadTask.taskIdentifier];
    NSAssert(imageDownload, @"did not find imageDownload for image!");
    
    [imageDownload URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

@end


