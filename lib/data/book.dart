
class Book{
  String? title;
  String? author;
  String? genre;
  String? description;
  String? imageUrl;
  String? readLink;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.imageUrl,
  });

  Book.fromJson(Map<String, dynamic> json){
    if (json['volumeInfo'].containsKey('title')){
      title = json['volumeInfo']['title'];
    }
    if (json['volumeInfo'].containsKey('authors')){
    author = json['volumeInfo']['authors'][0];
    }
    if (json['volumeInfo'].containsKey('categories')){
      genre = json['volumeInfo']['categories'][0];
    }
    if (json['volumeInfo'].containsKey('description')){
      description = json['volumeInfo']['description'];
    }
    if (json['volumeInfo'].containsKey('imageLinks')){
      if (json['volumeInfo']['imageLinks'].containsKey('thumbnail')){
        imageUrl = json['volumeInfo']['imageLinks']['thumbnail'];
      }
    }
    if (json['volumeInfo'].containsKey('previewLink')){
      readLink = json['volumeInfo']['previewLink'];
    }
  }

}

class BookList {
  List<Book> books= [];

  BookList.empty({this.books = const []});

  BookList(List<dynamic> json) {
    for (var book in json){
      books.add(Book.fromJson(book));
    }
  }
}