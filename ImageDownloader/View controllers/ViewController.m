//
//  ViewController.m
//  ImageDownloader
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "Downloader.h"
#import "ImageDownload.h"
#import "DownloadCell.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSProgress *totalProgress;

@property (nonatomic, weak) IBOutlet UIProgressView *totalProgressView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalProgress = [[NSProgress alloc] init];
    self.totalProgressView.observedProgress = _totalProgress;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (IBAction)didTapStartDownloadsButton {
    NSArray *urlStrings = @[@"http://www.droid-life.com/wp-content/uploads/2012/12/Steve-Jobs-Apple.jpg",
                            @"http://2.bp.blogspot.com/-T6nbl0rQoME/To0X5FccuCI/AAAAAAAAEZQ/ipUU7JfEzTs/s1600/steve-jobs-in-time-magazine-front-cover.png",
                            @"http://cdn.ndtv.com/tech/gadget/image/steve-jobs-face.jpg"];
    
    self.totalProgress.totalUnitCount = urlStrings.count;
    for (NSInteger i = 0; i < urlStrings.count; i++) {
        NSURL *url = [NSURL URLWithString:urlStrings[i]];
        NSString *filename = [NSString stringWithFormat:@"image%ld.%@", (long)i, url.pathExtension];
        ImageDownload *imageDownload = [[Downloader sharedDownloader] startDownload:url filename:filename];
        [self.totalProgress addChild:imageDownload.progress withPendingUnitCount:1];
    }
    
    [self.tableView reloadData];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Downloader sharedDownloader].imageDownloads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    
    ImageDownload *imageDownload = [Downloader sharedDownloader].imageDownloads[indexPath.row];
    cell.progressView.observedProgress = imageDownload.progress;
    cell.filenameLabel.text = imageDownload.filename;
    
    return cell;
}

@end
