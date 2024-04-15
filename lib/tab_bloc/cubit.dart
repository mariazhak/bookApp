import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';
import 'package:http/http.dart' as http;
import 'package:app7/data/book.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabInitial());

  void changeTab(int index) {
    emit(TabData(currentIndex: index, favorites: state.favorites, searchResults: state.searchResults));
  }

  List<Book> get favorites => state.favorites;

  void addToFavorites(Book book) {
    state.favorites.add(book);
    emit(ChangeFavorite(favorites: state.favorites, searchResults: state.searchResults));
  }

  void removeFromFavorites(Book book) {
    state.favorites.remove(book);
    emit(ChangeFavorite(favorites: state.favorites, searchResults: state.searchResults));
  }

  void getBooks(String search) async{
    emit(SearchData(search: search, favorites: state.favorites));
    search = search.toLowerCase().replaceAll(' ', '+');
    final http.Response response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$search+intitle&key=key'));
    BookList searchResults = BookList.empty();
    if(response.statusCode == 200) {
      print("Success");
      try{
        searchResults = BookList(jsonDecode(response.body)['items']);
      } catch (e, s) {
        print(e);
        print(s);
      }
      emit(SearchResult(searchResults: searchResults, favorites: state.favorites));
    }
    else{
      print("Failed");
      emit(SearchResult(searchResults: searchResults, favorites: state.favorites));
    }
  }
}