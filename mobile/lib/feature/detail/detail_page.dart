import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fodie_ai/common/common.dart';

import 'cubit/detail_cubit.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<DetailCubit>(), child: const Scaffold(body: DetailView()));
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const <Widget>[Text('Detail Page')]),
    );
  }
}
