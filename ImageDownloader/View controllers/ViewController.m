//
//  ViewController.m
//  ImageDownloader
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "ImageDownload.h"
#import "DownloadCell.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSProgress *totalProgress;

@property (nonatomic, weak) IBOutlet UIProgressView *totalProgressView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ImageDownload *> *imageDownloads;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalProgress = [[NSProgress alloc] init];
    self.totalProgressView.observedProgress = _totalProgress;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.imageDownloads = [NSMutableArray array];
}

- (IBAction)didTapStartDownloadsButton {
    NSArray *urlStrings = @[@"http://www.droid-life.com/wp-content/uploads/2012/12/Steve-Jobs-Apple.jpg",
                            @"http://2.bp.blogspot.com/-T6nbl0rQoME/To0X5FccuCI/AAAAAAAAEZQ/ipUU7JfEzTs/s1600/steve-jobs-in-time-magazine-front-cover.png",
                            @"http://cdn.ndtv.com/tech/gadget/image/steve-jobs-face.jpg"];
    
    NSURL *caches = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil] URLByAppendingPathComponent:@"images"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    self.totalProgress.totalUnitCount = urlStrings.count;
    for (NSInteger i = 0; i < urlStrings.count; i++) {
        NSURL *url = [NSURL URLWithString:urlStrings[i]];
        NSString *filename = [NSString stringWithFormat:@"image%ld.%@", (long)i, url.pathExtension];
        ImageDownload *imageDownload = [[ImageDownload alloc] initWithURL:url filename:filename];
        [self.imageDownloads addObject:imageDownload];
        [self.totalProgress addChild:imageDownload.progress withPendingUnitCount:1];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            [imageDownload updateProgressForTotalBytesWritten:downloadProgress.completedUnitCount
                                    totalBytesExpectedToWrite:downloadProgress.totalUnitCount];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imageDownload.progress.totalUnitCount = downloadProgress.totalUnitCount;
//                imageDownload.progress.completedUnitCount = downloadProgress.completedUnitCount;
//                [
//            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [caches URLByAppendingPathComponent:filename];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //do whatever you want here
        }];
        [task resume];
    }
    
    [self.tableView reloadData];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageDownloads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    
    ImageDownload *imageDownload = self.imageDownloads[indexPath.row];
    cell.progressView.observedProgress = imageDownload.progress;
    cell.filenameLabel.text = imageDownload.filename;
    
    return cell;
}

@end
