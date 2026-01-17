// Conditional export based on platform
export 'network_image_widget_mobile.dart' 
    if (dart.library.html) 'network_image_widget_web.dart';
