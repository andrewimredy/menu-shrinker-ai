// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:fodie_ai/common/common.dart' as _i606;
import 'package:fodie_ai/common/constant/config.dart' as _i889;
import 'package:fodie_ai/common/injection/api_module.dart' as _i166;
import 'package:fodie_ai/common/injection/third_party_module.dart' as _i710;
import 'package:fodie_ai/common/network/api/user_api.dart' as _i464;
import 'package:fodie_ai/common/network/interceptor/base_interceptor.dart'
    as _i81;
import 'package:fodie_ai/common/network/interceptor/error_interceptor.dart'
    as _i669;
import 'package:fodie_ai/common/network/interceptor/logger_interceptor.dart'
    as _i167;
import 'package:fodie_ai/common/repository/chats_repository.dart' as _i600;
import 'package:fodie_ai/common/repository/user_repository.dart' as _i445;
import 'package:fodie_ai/common/service/chats_service.dart' as _i510;
import 'package:fodie_ai/common/service/device_info.dart' as _i205;
import 'package:fodie_ai/common/service/iap_service.dart' as _i509;
import 'package:fodie_ai/common/service/user_service.dart' as _i419;
import 'package:fodie_ai/feature/detail/cubit/detail_cubit.dart' as _i685;
import 'package:fodie_ai/feature/home/cubit/home_cubit.dart' as _i600;
import 'package:fodie_ai/feature/login/cubit/login_cubit.dart' as _i442;
import 'package:fodie_ai/feature/setting/cubit/setting_cubit.dart' as _i871;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:in_app_purchase/in_app_purchase.dart' as _i690;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:logger/logger.dart' as _i974;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModule = _$ThirdPartyModule();
    final apiModule = _$ApiModule();
    gh.factory<_i583.GoRouter>(() => thirdPartyModule.router);
    gh.factory<_i974.Logger>(() => thirdPartyModule.logger);
    gh.factory<_i973.InternetConnectionChecker>(
        () => thirdPartyModule.internetConnectionChecker);
    gh.factory<_i116.GoogleSignIn>(() => thirdPartyModule.googleSignIn);
    gh.factory<_i59.GoogleAuthProvider>(
        () => thirdPartyModule.googleAuthProvider);
    gh.factory<_i974.FirebaseFirestore>(() => thirdPartyModule.firestore);
    gh.factory<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.factory<_i690.InAppPurchase>(() => thirdPartyModule.inAppPurchase);
    gh.factory<_i600.HomeCubit>(() => _i600.HomeCubit());
    gh.factory<_i685.DetailCubit>(() => _i685.DetailCubit());
    gh.singleton<_i600.ChatsRepository>(() => _i600.ChatsRepository());
    gh.singleton<_i81.RequestIdProvider>(() => _i81.RequestIdProvider());
    gh.singleton<_i889.Config>(() => _i889.Config());
    await gh.singletonAsync<_i205.DeviceInfoProvider>(
      () {
        final i = _i205.DeviceInfoProvider();
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i509.IapService>(() => _i509.IapService(
          gh<_i690.InAppPurchase>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i510.ChatsService>(
        () => _i510.ChatsService(chatsRepository: gh<_i606.ChatsRepository>()));
    gh.factory<_i669.ErrorInterceptor>(() => _i669.ErrorInterceptor(
        connectionChecker: gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i167.LoggerInterceptor>(
        () => _i167.LoggerInterceptor(logger: gh<_i974.Logger>()));
    gh.factory<_i464.UserApi>(() => _i464.UserApi(
          gh<_i116.GoogleSignIn>(),
          gh<_i59.GoogleAuthProvider>(),
          gh<_i974.FirebaseFirestore>(),
          gh<_i59.FirebaseAuth>(),
        ));
    gh.factory<_i81.BaseInterceptor>(() => _i81.BaseInterceptor(
          deviceInfoProvider: gh<_i606.DeviceInfoProvider>(),
          requestIdProvider: gh<_i81.RequestIdProvider>(),
          config: gh<_i606.Config>(),
        ));
    gh.singleton<_i445.UserRepository>(
        () => _i445.UserRepository(gh<_i606.UserApi>()));
    gh.factory<_i361.Dio>(() => apiModule.dio(
          gh<_i606.Config>(),
          gh<_i606.BaseInterceptor>(),
          gh<_i606.LoggerInterceptor>(),
          gh<_i606.ErrorInterceptor>(),
        ));
    gh.factory<_i419.UserService>(() => _i419.UserService(
          userRepository: gh<_i606.UserRepository>(),
          userApi: gh<_i606.UserApi>(),
          googleSignIn: gh<_i116.GoogleSignIn>(),
          firebaseAuth: gh<_i59.FirebaseAuth>(),
        ));
    gh.factory<_i871.SettingCubit>(
        () => _i871.SettingCubit(gh<_i606.UserService>()));
    gh.factory<_i442.LoginCubit>(
        () => _i442.LoginCubit(gh<_i606.UserService>()));
    return this;
  }
}

class _$ThirdPartyModule extends _i710.ThirdPartyModule {}

class _$ApiModule extends _i166.ApiModule {}
