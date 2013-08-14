//
//  ViewController.m
//  SampleAppiOS
//
//  Created by Reza Fatahi on 8/8/13.
//  Copyright (c) 2013 Rex Fatahi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <NSStreamDelegate>
{
    SocketIO* socketIO;
    
    __weak IBOutlet UILabel     *oLabel;
    __weak IBOutlet UITextField *oTextField;
    __weak IBOutlet UITextView  *oTextView;
    __weak IBOutlet UITableView *oTableView;
    
    NSMutableData*  mutableData;
    NSString*       suggestedFilename;
    
    NSInputStream*  inputStream;
    NSOutputStream* outputStream;
    NSArray*        sailsArray;
}

- (IBAction)submitText:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    oLabel.hidden = YES;
    //handshake
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:1337/"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //converts response to string (index.html)
    NSString* stringFromData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"data converted to string ==> string = %@", stringFromData);
    
    //init socket.io
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:1337];
    
}

#pragma mark-table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sailsArray.count == 0) {
        return 1;
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        oLabel.hidden = YES;
    });
    return sailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    }
    
    if (sailsArray.count == 0) {
        cell.textLabel.text = @"array does not exist (yet)";
        return cell;
    }
    //declare string, assign to value at indexPath from array
    //array may be made from [dictionary allKeys];
    NSString* string = [[sailsArray objectAtIndex:indexPath.row] valueForKey:@"text"];
    NSString* subString = [[sailsArray objectAtIndex:indexPath.row] valueForKey:@"createdAt"];
    
    //set string to textLabel of cell
    [cell.textLabel setText:string];
    [cell.detailTextLabel setText:subString];
    
    return cell;
}

#pragma mark -textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength>30) {
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Text" message:@"is too lengthy" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    	[alert show];
    	return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    mutableData = [NSMutableData data];
    //suggestedFilename = response.suggestedFilename;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mutableData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    oTextView.text = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/messages"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        sailsArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [oTableView reloadData];
    }];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark -action methods
- (IBAction)submitText:(id)sender
{
    [oTextField resignFirstResponder];
    oLabel.hidden = NO;
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://localhost:1337/messages"]];
    NSString* inputString = oTextField.text;
    NSString *params = [[NSString alloc] initWithFormat:@"text=%@", inputString];
    oTextField.text = nil;
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}


@end
