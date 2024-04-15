import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app7/tab_bloc/cubit.dart';
import 'package:app7/data/book.dart';
import 'booktile.dart';
import 'package:app7/tab_bloc/state.dart';

class Favourites extends StatelessWidget {

  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, TabState>(builder: (context, state)=>
      Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: state.favorites.length,
          itemBuilder: (context, index) =>
          Column(
            children: [
              BookTile(book: state.favorites[index]),
              const SizedBox(height: 10),
            ],
          ),
            ),
      ),
    );
  }
}