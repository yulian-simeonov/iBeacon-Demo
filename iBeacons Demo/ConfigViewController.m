//
//  TrackViewController.m
//  PrimalPal
//
//  Created by Yulian Simeonov on 7/23/14.
//  Copyright (c) 2014 YuriiBogdan. All rights reserved.
//

#import "ConfigViewController.h"
#import "AppDelegate.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)transmitBeacon:(UIButton *)sender {
    if (self.uuidLabel.text.length == 0 || self.majorLabel.text.length == 0 || self.minorLabel.text.length == 0) {
        return;
    }
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.uuidLabel.text] ;//@"23542266-18D1-4FE4-B4A1-23F8195B9D39"
    
    //Save UUID to app delegate
    AppDelegate*_appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_appDelegate setStrUUID:self.uuidLabel.text];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:[self.majorLabel.text intValue]  //1
                                                                minor:[self.minorLabel.text intValue]  //1
                                                           identifier:@"com.devfright.myRegion"];
  
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                                     queue:nil
                                                                                   options:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
