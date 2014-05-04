#import "BLEProximity.h"
#import <Cordova/CDV.h>

@implementation BLEProximity

// keep a note of the callback id so that background monitoring can still be returned
NSString *callbackId;

// plugin result object
CDVPluginResult* pluginResult;

/*
 * attempt to initialise BLE
 */
- (void)init:(CDVInvokedUrlCommand*)command
{
    NSLog(@"Initting BLEProximity");
    
    // nullify result and store callback id
    pluginResult = nil;
    callbackId = command.callbackId;
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    // attempt to turn on ble using self as delegate
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

/*
 * start scanning for available ble peripherals
 */
- (void)scan:(CDVInvokedUrlCommand*)command
{
    // run as background thread so app doesn't hang
    [self.commandDelegate runInBackground:^{
        NSLog(@"Scanning for BLE Peripherals");
        
        // nullify any previous result
        pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        callbackId = command.callbackId;
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];

        // start scanning for all BLE peripherals
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
    }];
}



/*
 * called when the state of phones BLE is changed.
 * the result is sent to the most recent callbackId (which should be from the initBLE method unless something goes wrong!)
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"State unknown, update imminent.");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"State unknown, update imminent."];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"The connection with the system service was momentarily lost, update imminent."];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"The platform doesn't support Bluetooth Low Energy");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"The platform doesn't support Bluetooth Low Energy"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"The app is not authorized to use Bluetooth Low Energy");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"The app is not authorized to use Bluetooth Low Energy"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"Bluetooth is currently powered off.");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Bluetooth is currently powered off."];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"Bluetooth is currently powered on and available to use");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Bluetooth is currently powered on and available to use"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            break;
        }
    }
}

/*
 * method will run when a BLE peripheral is discovered. Callback to the method defined when startScanning was invoked
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    
    // send result to js app
    NSString *response = [NSString stringWithFormat:@"%@,%@", peripheral.name, RSSI];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:response];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end