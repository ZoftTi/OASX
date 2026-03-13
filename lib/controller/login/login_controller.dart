part of login;

class LoginController extends GetxController {
  static bool logined = false;
  var username = ''.obs;
  var password = ''.obs;
  var address = ''.obs;

  GetStorage storage = GetStorage();

  @override
  Future<void> onInit() async {
    username.value = storage.read(StorageKey.username.name) ?? "";
    password.value = storage.read(StorageKey.password.name) ?? "";
    address.value = storage.read(StorageKey.address.name) ?? "";

    if (address.value.isNotEmpty && !logined) {
      logined = true;
      await login(address.value);
    }
    super.onInit();
  }

  /// 进入主页面
  Future<void> toMain({required Map<String, dynamic> data}) async {
    storage.write(StorageKey.username.name, data['username']);
    storage.write(StorageKey.password.name, data['password']);
    storage.write(StorageKey.address.name, data['address']);
    printInfo(info: data.toString());
    await login(data['address']);
  }

  Future<void> login(String address) async {
    address = address.trim();

    // 没协议就加 http
    if (!address.contains('://')) {
      address = 'http://$address';
    }

    final uri = Uri.parse(address);
    ApiClient().setAddress(uri.toString());
    if (await ApiClient().testAddress()) {
      Get.offAllNamed('/main');
    } else {
      Get.snackbar('Error', 'Failed to connect to OAS server');
    }
  }
}
