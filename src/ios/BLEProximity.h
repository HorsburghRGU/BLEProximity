#import <Cordova/CDV.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEProximity : CDVPlugin <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
- (void)init:(CDVInvokedUrlCommand*)command;
- (void)scan:(CDVInvokedUrlCommand*)command;
@end