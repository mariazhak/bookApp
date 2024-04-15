import 'package:flutter/material.dart';
import 'package:app7/data/book.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app7/tab_bloc/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({super.key, required this.book});

  void _launchURL(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch';
    }
  }

  List<Book> _favorites (BuildContext context){
    return context.read<TabCubit>().favorites;
  }

  void _addFavourite(Book book, BuildContext context) {
    context.read<TabCubit>().addToFavorites(book);
  }

  void _removeFavourite(Book book, BuildContext context) {
    context.read<TabCubit>().removeFromFavorites(book);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(book.title??"Unknown title"),
        subtitle: Text(book.author??"Unknown author"),
        leading: const Icon(Icons.book),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 100,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network("https://img.freepik.com/free-photo/book-composition-with-open-book_23-2147690555.jpg?size=626&ext=jpg&ga=GA1.1.632798143.1713052800&semt=ais",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Image.network(book.imageUrl!),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text(book.title??"Unknown title",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(book.author??"Unknown author"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Genre: ${book.genre??"Unknown genre"}'),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(book.description??"No description available"),
                      ),
                      Row(
                          children:[
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: ()=>{
                                if (_favorites(context).contains(book)){
                                  _removeFavourite(book, context)
                                } else {
                                  _addFavourite(book, context)
                                }
                              },
                              child: Text('To favorites', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: ()=> _launchURL(Uri.parse(book.readLink??'https://books.google.com.ua/')),
                              child:  Text('Read', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                            ),
                          ]
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}