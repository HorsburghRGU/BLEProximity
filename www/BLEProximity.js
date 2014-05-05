BLEProximity = {};

BLEProximity.init = function(onInitSuccess, onInitFail)
{
	cordova.exec(onInitSuccess, onInitFail, "BLEProximity", "init", [""]);
}
BLEProximity.scan = function(onScanSuccess, onScanFail)
{
    cordova.exec(onScanSuccess, onScanFail, "BLEProximity", "scan", [""]);
}

module.exports = BLEProximity;