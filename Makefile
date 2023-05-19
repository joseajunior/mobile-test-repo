run_all_in_parallel:
	make -j test_Driver_Dash_Android_Samsung_Galaxy_S22_5G test_Driver_Dash_iOS_iPhone_13 test_Driver_Dash_Android_Pixel_7

test_Driver_Dash_Android_Samsung_Galaxy_S22_5G:
	robot --variable version:12 --variable platformName:android --variable deviceName:"Galaxy S22 5G" --variable isRealMobile:true --variable visual:false --variable network:false --variable console:false --report None --output reports/DriverDash/Android/DriveDash_samsung_output.xml --log reports/DriverDash/Android/DriverDash_samsung_log.html --exclude test DriverDash/tests/Android/DriverDash.robot

test_Driver_Dash_Android_Pixel_7:
	robot --variable version:12 --variable platformName:android --variable deviceName:"Pixel 6" --variable isRealMobile:true --variable visual:false --variable network:false --variable console:false --report None --output reports/DriverDash/Android/DriveDash_pixel_output.xml --log reports/DriverDash/Android/DriverDash_pixel_log.html --exclude test DriverDash/tests/Android/DriverDash.robot

test_Driver_Dash_iOS_iPhone_13:
	robot --variable version:16 --variable platformName:ios --variable deviceName:"iPhone 13" --variable isRealMobile:true --variable visual:false --variable network:false --variable console:false --report None --output reports/DriverDash/iOS/DriveDash_iphone_13_output.xml --log reports/DriverDash/iOS/DriverDash_iphone_13_log.html --exclude test DriverDash/tests/iOS/DriverDash.robot

test_Driver_Dash_iOS_iPad:
	robot --variable version:16 --variable platformName:ios --variable deviceName:"iPad 10.9 (2022)" --variable isRealMobile:true --variable visual:false --variable network:false --variable console:false --report None --output reports/DriverDash/iOS/DriveDash_ipad_output.xml --log reports/DriverDash/iOS/DriverDash_ipad_log.html --exclude test DriverDash/tests/iOS/DriverDash.robot
