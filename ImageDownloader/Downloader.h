//
//  Downloader.h
//  ImageDownloader
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

@import Foundation;

@class ImageDownload;

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject

@property (class, nonatomic, strong, readonly) Downloader *sharedDownloader;

@property (nonatomic, strong) NSMutableArray <ImageDownload *> *imageDownloads;

- (instancetype)init __attribute__((unavailable("Use +[Downloader sharedDownloader] instead")));
+ (instancetype)new __attribute__((unavailable("Use +[Downloader sharedDownloader] instead")));

- (ImageDownload *)startDownload:(NSURL *)url filename:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
