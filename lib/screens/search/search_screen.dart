import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappwithapi/components.dart';
import 'package:shopappwithapi/cubit/search_cubit/cubit.dart';
import 'package:shopappwithapi/cubit/search_cubit/states.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchContrller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, states) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Search Screen'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Expanded(
                        child: Column(
                          children: [
                            defaultFormField(
                                controller: searchContrller,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'enter text to search ';
                                  }
                                  return null;
                                },
                                onSubmit: (String text) {
                                  SearchCubit.get(context).search(text);
                                },
                                label: 'Search',
                                prefix: Icons.search),
                            SizedBox(
                              height: 10,
                            ),
                            if (state is SearchLoadingState)
                              LinearProgressIndicator(),
                            SizedBox(height: 10),
                            if (state is SearchSuccessState)
                              Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        buildListProducts(
                                            SearchCubit.get(context)
                                                .model
                                                .data
                                                .data[index],
                                            context,
                                            isOldPrice: false),
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: SearchCubit.get(context)
                                        .model
                                        .data
                                        .data
                                        .length),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
