import 'dart:async';

import 'package:cached_repository/cached_repository.dart' as repo;
import 'package:cached_resource/cached_resource.dart' as resource;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../common/common.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
  ) : super(const HomeState());

}
