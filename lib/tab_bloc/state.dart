import 'package:flutter/material.dart';
import 'package:app7/data/book.dart';
import 'package:app7/widgets/search.dart';
import 'package:app7/widgets/favourites.dart';

abstract class TabState{
  int currentIndex;
  List<Book> favorites= [];
  String search = '';
  BookList searchResults = BookList.empty();
  Future<BookList> books = Future.value(BookList.empty());

  final List<Widget> tabs =[
     PageSearch(),
    const Favourites(),
  ];

  TabState({required this.currentIndex});
  TabState.searchResults({required this.searchResults, this.currentIndex = 0});
  TabState.search({required this.search, this.currentIndex = 0});
  TabState.favorites({required this.favorites, this.currentIndex = 0});
}

class TabInitial extends TabState {
  TabInitial() : super(currentIndex: 0);
}

class TabData extends TabState {
  TabData({required super.currentIndex, required favorites, required searchResults}){
    super.favorites = favorites;
    super.searchResults = searchResults;
  }
}

class SearchResult extends TabState{
  SearchResult({required searchResults, required favorites}): super.searchResults(searchResults: searchResults){
    super.favorites = favorites;
  }
}

class SearchData extends TabState{
  SearchData({required search, required favorites}): super.search(search: search){
    super.favorites = favorites;
  }
}

class ChangeFavorite extends SearchResult{
  ChangeFavorite({required favorites, required searchResults}): super(searchResults: searchResults, favorites: favorites);
}
