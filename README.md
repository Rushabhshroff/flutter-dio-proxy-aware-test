# flutter-dio-proxy-aware-test

* This repository demonstrates usage of flutter **[dio](https://pub.dev/packages/dio)** (Http Client Library) in environments with proxy
* Follow external package is used **[system_proxy](https://pub.dev/packages/system_proxy)**

# Steps to Run 

* Clone the repository
* Open Project in a Code Editor
* Generate Apk using `flutter build`

# Important Code to look at

```
    import 'package:system_proxy/system_proxy.dart';
    .
    .
    .
    Future<Dio> getDio() async {
    var proxy = "DIRECT";
    var proxySettings = await SystemProxy.getProxySettings();
    if (proxySettings != null) {
        var host = proxySettings['host'];
        var port = proxySettings['port'];
        proxy = 'PROXY $host:$port';
    }
    var dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
            client.findProxy = (uri) {
        return proxy;
        };
    };
    return dio;
    }
```

# Mentioned External Package uses following

* Android: https://developer.android.com/reference/android/net/ConnectivityManager#getDefaultProxy()
* Ios: https://developer.apple.com/documentation/cfnetwork/1426754-cfnetworkcopysystemproxysettings