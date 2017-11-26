# E32SettingsManager
A lightweight and intuitive object that manages app settings

This object is intended to make managing in-app settings simple and intuitive.  This is not intended to replace settings that would normally be adjusted in the settings app of an iOS device.  This is intended for settings that are internal to an app and only intended to be changed within the app.

This object works with settings as an immutable NSDictionary.  Setting must be changed using the changeSetting:toValue: method.  As a dictionary, settings must be named with NSStrings.  Currently, this object can only work with settings that are NSStrings, NSDates, or NSNumbers.  The object will simply ignore other datatypes passed in for settings.  The consumer is responsible for passing in the correct datatype for each setting.

If a settings file doesn't exist a new file will be created.  If a setting doesn't already exist, a new one will be added to the settings dictionary.

This object will attempt to save itself to file automatically if the object is removed from memory.
