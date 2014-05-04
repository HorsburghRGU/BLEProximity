var BLEProximity = {

	init: function(onInitSuccess, onInitFail)
	{
		cordova.exec(onInitSuccess, onInitFail, "BLE", "init", [""]);
	},
	
	scan: function(onScanSuccess, onScanFail)
	{
		cordova.exec(onScanSuccess, onScanFail, "BLE", "scan", [""]);
	}
}