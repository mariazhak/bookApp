import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app7/tab_bloc/cubit.dart';
import 'package:app7/data/book.dart';
import 'package:app7/tab_bloc/state.dart';
import 'package:app7/widgets/booktile.dart';


class PageSearch extends StatelessWidget{
  TextEditingController controller = TextEditingController();
  Future<BookList> books = Future.value(BookList.empty());

  PageSearch({super.key});

  void _getBooks(String search, BuildContext context) {
     context.read<TabCubit>().getBooks(search);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children:[
            TextField(
              controller: controller,
              onSubmitted: (text) => _getBooks(text, context),
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            //ElevatedButton(onPressed: ()=> _getBooks('flower', context), child: const Text('Search')),
            BlocBuilder<TabCubit, TabState>(
              builder: (context, state) {
                  if (state is SearchData) {
                    return const CircularProgressIndicator();
                  }
                  else if ((state is SearchResult && state.searchResults.books.isNotEmpty) || (state is TabData && state.searchResults.books.isNotEmpty)){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.searchResults.books.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              BookTile(book: state.searchResults.books[index]),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  else if (state is SearchResult && state.searchResults.books.isEmpty){
                    return const Text('No books found!');}
              else{
                return const Center();
              }
              },
            ),
          ],
        ),
    );
  }
}