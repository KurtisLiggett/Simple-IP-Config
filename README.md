# Simple-IP-Config
View and change your local IP addresses.

v2.8
MAJOR CHANGES:
   Now using IP Helper API (Iphlpapi.dll) instead of WMI
   Speed improvements -> 2x faster!

MINOR CHANGES:
   Automatically fill in 255.255.255.0 for subnet
   Save last window position on exit
   Tray message when an trying to start a new instance
   Smaller exe file size
   Popup window positioning follows main window
   Allow more space for current properties
   Smoother startup process
   Get current information from disconnected adapters

BUG FIXES:
   IP address entry text scaling
   Fixed 'start in system tray' setting
   Fixed starting without toolbar icons
   Display disabled adapters
   Get current properties from disabled adapters
   Disabled adapters behavior
   Fixed hanging on setting profiles
   Fixed renaming/creating profiles issues
   Fixed additional DPI scaling issues
