//
//  DownloadCell.h
//  ImageDownloader
//
//  Created by Robert Ryan on 3/20/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *filenameLabel;

@end
