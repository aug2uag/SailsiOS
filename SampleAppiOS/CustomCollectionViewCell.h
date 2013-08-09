//
//  CustomCollectionViewCell.h
//  SampleAppiOS
//
//  Created by Reza Fatahi on 8/8/13.
//  Copyright (c) 2013 Rex Fatahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
{
    
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UITextView *textView;
    
}

@end
