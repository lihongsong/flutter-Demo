import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// 单行函数
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'welcome to flutter',
      // 应用程序主题色修改
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override
  // 以下划线开头的字段为私有字段
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.black);
  final _saved = new Set<WordPair>();

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            }
          );
          final divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles
          )
          .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final isSaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : null,
      ),
      // 每行添加点击事件
      onTap: () {
        // 点击事件会调用 setState 方法，调用 setState() 方法会为 State 触发 build () 方法，从而通知框架更新 UI
        setState(() {
          if (isSaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // isOdd 为判断偶数，在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        // 如果是列表中的最后一个
        if (index >= _suggestions.length) {
          // 再添加十条数据
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget build(BuildContext content) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('StartUp Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
