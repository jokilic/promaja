'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "29a467c241c488ea92097882a452c74d",
"version.json": "f0930f0f11597cf6c9762a5d48c272c7",
"index.html": "5b8ea3040618025a040b4bd4d472bf3d",
"/": "5b8ea3040618025a040b4bd4d472bf3d",
"main.dart.js": "17fda178ab70361dc4476f6544fe8866",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "4343f1169bd1d36d24043344b503869b",
"main.dart.mjs": "fc19feefbd23c42d629352356cb6a09d",
"icons/Icon-192.png": "a3b9c6d6356e41770adc55f2da6dc40a",
"icons/Icon-maskable-192.png": "a3b9c6d6356e41770adc55f2da6dc40a",
"icons/Icon-maskable-512.png": "f34663f24081e0cee2cccc74432787cc",
"icons/Icon-512.png": "f34663f24081e0cee2cccc74432787cc",
"manifest.json": "0d702ebd45fc1c26da38fe3d59a5ebf9",
"main.dart.wasm": "6f9c595cdaf9a086968da65bda3de2ee",
"assets/AssetManifest.json": "6f7a3a5e68bbcbedf18d8a486a43c0d6",
"assets/NOTICES": "37f804fde58f15e56826c873e5f98631",
"assets/FontManifest.json": "dc59f7db734a389d2d7bf79d2a32e637",
"assets/AssetManifest.bin.json": "96287854b4abc9a92143d51a86bbc72b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "091bf00d81c49abcefb83e0f3fb04b3b",
"assets/fonts/MaterialIcons-Regular.otf": "c5a440d9706d1f641889d276a5501740",
"assets/assets/icon.png": "7efc29b2131b09e15a6e923317da6432",
"assets/assets/icons/weatherapi.webp": "fb5e4537338d1b1fa7a9c9c8949ac8cf",
"assets/assets/icons/check.png": "40a6e8b1f9476ceec87ac1bd30c6cafe",
"assets/assets/icons/icon.png": "491aea593b8cebe4e81aecff4bf38e48",
"assets/assets/icons/pressure.png": "0e0e0a8649a646868f9d529536fb399c",
"assets/assets/icons/uv.png": "d62180878933762a5f855216da98fc3f",
"assets/assets/icons/settings.png": "4b9e53bdaa7465457d2a79dd9a0e275a",
"assets/assets/icons/dot.png": "779e09a6e6bc1cbb2090f1fcba007622",
"assets/assets/icons/visibility.png": "9d0d00d2ac8045c19414b3829ef597d5",
"assets/assets/icons/nologging.png": "97ca86d1cc8330f4d327d6883b92074a",
"assets/assets/icons/umbrella.png": "934c035ed0e67004d55f2f94d2dee3f7",
"assets/assets/icons/arrow.png": "865f264dd3f50d037f7fc51704353abe",
"assets/assets/icons/snow.png": "ab3aac30071bceb3ea5a673907fc8ed9",
"assets/assets/icons/temperature.png": "9bf17b9e77a49496a1791aeec71bc2e0",
"assets/assets/icons/wind.png": "370c1ad9e6287405d0bce3a69a99bed2",
"assets/assets/icons/list.png": "0b721e533aedc38aa39530818148fc99",
"assets/assets/icons/search.png": "2ffd0e2a3d1ed091fb5e4fc5775e6347",
"assets/assets/icons/test.png": "e50d22543b922f2364254b7467fae949",
"assets/assets/icons/tempmaxmin.png": "0ff2e8d8e6a11173f00d4f9107fced45",
"assets/assets/icons/cloud.png": "5a38187e08e6f8655540f8028d14a8aa",
"assets/assets/icons/globe.png": "c0b2145ebc84e8b75a2c481301e214af",
"assets/assets/icons/calendar.png": "db041557dbfd68a3527f26616de89a06",
"assets/assets/icons/dontknow.png": "59cff2c68b911d3a73f1d33375a1745c",
"assets/assets/icons/location.png": "ff7abca3d128c9c731b0b4d984f4ccb7",
"assets/assets/icons/precipitation.png": "54a2cbeeb1f3df85c9d5a43166701dcc",
"assets/assets/icons/gust.png": "98e394728214c69544453219cb157430",
"assets/assets/icons/sun.png": "476249666a5d0fd39d4239627ec8fb27",
"assets/assets/icons/humidity.png": "5bbe3c0178741683abb775f33998ffdb",
"assets/assets/icons/feelslike.png": "fe7b805b6f16ba65096df0001f92dc30",
"assets/assets/weather/moon_fast_wind.png": "6f183bd59e92975f4a04f85b2fc3864f",
"assets/assets/weather/big_snow_little_snow.png": "23691be0e98691e708c848f0b7c20d7e",
"assets/assets/weather/sun_cloud_zap.png": "f2aa3f4161d1fbea6e2b551d7d474757",
"assets/assets/weather/sun_cloud_big_rain.png": "696f139298177399a36b8f9c628d6333",
"assets/assets/weather/moon_cloud_little_snow.png": "8554530fa72042f4d5a491a0bf4d15f1",
"assets/assets/weather/mid_snow_slow_winds.png": "411549049bfabdab09ff1ade030ed713",
"assets/assets/weather/moon_cloud_mid_snow.png": "90179b432115ed4a4f644eea0730b566",
"assets/assets/weather/cloud_slow_wind.png": "58ecfe9440a48977212fad17a8675d6f",
"assets/assets/weather/cloud_zap.png": "356aec0c64cfbc1d7098bbe815eab2c4",
"assets/assets/weather/sun_cloud_hailstone.png": "1d4ce1382e5397bb02cc33553aa31a4e",
"assets/assets/weather/sun_cloud_little_rain.png": "80323850db557b025ecf189faf4af73a",
"assets/assets/weather/tornado.png": "08e57ecd88c57d12fe2f6ab27722dcd1",
"assets/assets/weather/cloud_fast_wind.png": "297e8276a568c5b9713d20aebf5ff145",
"assets/assets/weather/sun_cloud_angled_rain.png": "07b7224bb5113aed843267b42799b30e",
"assets/assets/weather/moon_cloud_big_rain.png": "f397d25069f7fd10d186455c825dc18a",
"assets/assets/weather/mid_snow_fast_winds.png": "c1a8063a35d6ce61e12db98a6c8da7e8",
"assets/assets/weather/cloud_little_snow.png": "d5f2fd783c9d07a5742ba2314b55fa2a",
"assets/assets/weather/zaps.png": "238db3b993f490f8a6c9a5292d259a90",
"assets/assets/weather/cloud_sunset.png": "588e31852d98680423de790a56daf337",
"assets/assets/weather/moon_cloud_snow.png": "3f96303166dccdc6eb2b97293532bbd5",
"assets/assets/weather/big_snow.png": "4b64bdce0df40bbd6339e1fcca7dea33",
"assets/assets/weather/cloud_mid_rain.png": "0a870e7669b5440abdc986524c11d754",
"assets/assets/weather/sun_cloud_mid_snow.png": "c4f9c3ea33c363e6daeeade6936b6275",
"assets/assets/weather/moon_cloud_hailstone.png": "9d5ba35e195a796175933181ad7fc827",
"assets/assets/weather/moon_slow_wind.png": "5e9155d9b70d452d50d72ea2853cb96d",
"assets/assets/weather/moon_cloud_little_rain.png": "5da42d5a9d8b509eb2038f3d3fa2f9b3",
"assets/assets/weather/cloud_big_rain.png": "0a9affce9e392f04497133e56acf634d",
"assets/assets/weather/sun_cloud_slow_wind.png": "a135d3d8ba3240aa619e2f2bb8c4ef58",
"assets/assets/weather/moon.png": "9c777e62f37b9c1103adbb5a20e7494d",
"assets/assets/weather/moon_cloud_angled_rain.png": "3e0b439efb25d10abfcabebbf950c214",
"assets/assets/weather/layers.jsx": "a33aa507bf40a400a75d87955882de85",
"assets/assets/weather/cloud.png": "beb81019db2cd80d43c0239c652a0ce9",
"assets/assets/weather/moon_cloud.png": "0bd041f1b73092272d442645eab1b507",
"assets/assets/weather/cloud_3_zap.png": "fc8755d7446d2e80b77bfff1a5f2dc43",
"assets/assets/weather/moon_cloud_slow_wind.png": "a7f888073cc81a4f92b6b7822a269427",
"assets/assets/weather/moon_cloud_mid_rain.png": "08cddaec3d2d20dca6e57a776cefbc35",
"assets/assets/weather/slow_winds.png": "03a4a4c463635eb59f6517720ff0db95",
"assets/assets/weather/sun_slow_wind.png": "18999f411ae43f53714458f9cb94aea3",
"assets/assets/weather/cloud_snow.png": "ded734ead696e03b78c559a5501ff79a",
"assets/assets/weather/sun_cloud_snow.png": "85292ec3e2260946226599fb62b45c11",
"assets/assets/weather/fast_winds.png": "29014d09d223241c266907252f23cce6",
"assets/assets/weather/sun_fast_wind.png": "ed9ef04c01c53da85f4cfe3daf023aba",
"assets/assets/weather/cloud_angled_rain.png": "a83f81441a40a6b34b7abd2546e68e10",
"assets/assets/weather/cloud_little_rain.png": "27631a11a3ccd913961649d98924bd15",
"assets/assets/weather/moon_cloud_fast_wind.png": "103acd862706772d0dc0c1d88dd1d1d0",
"assets/assets/weather/cloud_angled_rain_zap.png": "60764b55637c4f70c1ff46cf073145d8",
"assets/assets/weather/moon_cloud_zap.png": "5be573be97fafec9cb313fdcb9309d8a",
"assets/assets/weather/sun.png": "918e22a45f4bcf1e87c3fa7e2c294d7b",
"assets/assets/weather/sun_cloud_little_snow.png": "59c6bae4732af7a4bc97cf6d9f6cded9",
"assets/assets/weather/moon_stars.png": "96f0f91cdeb49f80e55b5ad4e0a71279",
"assets/assets/weather/stars.png": "a4176ade92c93d28c3c41c599654c85c",
"assets/assets/weather/sun_cloud_mid_rain.png": "b05dd918dc1b4188f769ba16649af738",
"assets/assets/weather/sun_cloud.png": "70fe449276a7455cf7e4f38701cd3fdb",
"assets/assets/weather/big_rain_drops.png": "3003e6419fba93d9fb26263eac27836a",
"assets/assets/weather/cloud_hailstone.png": "0e18148477597fdacdad3e0d5390e2b1",
"assets/assets/weather/sun_cloud_fast_wind.png": "1ab1790e588bd8434308f226e762dc43",
"assets/assets/weather/cloud_mid_snow.png": "4a8494858b5804e85b12ffaa90e220de",
"assets/assets/weather/fast_winds_zaps.png": "e231028c025448247539ac00fdac9fd8",
"assets/assets/fonts/Jost-500.ttf": "845f5f797150ed9c3cc39c710929d273",
"assets/assets/fonts/Jost-700.ttf": "7b7ac714bb5ee8fda38602497d72e6d6",
"assets/assets/fonts/Jost-600.ttf": "8a96429a9f7193948f834fa0b643a0d6",
"assets/assets/translations/en.json": "12a6f82e8994cb902a32da7f792f6326",
"assets/assets/translations/hr.json": "7d41721b4e9f79d34b31906acf356b87",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
