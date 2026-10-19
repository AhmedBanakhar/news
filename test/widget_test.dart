import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widget/web_title.dart';

void main() {
  testWidgets('shows articles returned by the repository', (tester) async {
    await _pumpHome(tester, MyApp(repository: _FakeNewsRepository()));

    expect(find.text('Offline-ready headline'), findsOneWidget);
  });

  testWidgets('welcome screen can be skipped to open the home page', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(repository: _FakeNewsRepository()));
    await tester.pump();

    expect(find.text('WELCOME TO'), findsOneWidget);
    expect(find.text('NEWS CLOUD'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Top stories'), findsOneWidget);
  });

  testWidgets('welcome screen automatically opens the home page', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(repository: _FakeNewsRepository()));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(find.text('Top stories'), findsOneWidget);
  });

  testWidgets('home layout fits a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpHome(tester, MyApp(repository: _FakeNewsRepository()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('search can be cleared from the input', (tester) async {
    final repository = _FakeNewsRepository();
    await _pumpHome(tester, MyApp(repository: repository));

    await tester.enterText(find.byType(TextField), 'technology');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Search results'), findsOneWidget);
    expect(repository.queries.last, 'technology');

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('Top stories'), findsOneWidget);
    expect(repository.queries.last, '');
  });

  testWidgets('article detail displays the feature story and summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: WebTitle(
                article: ArticleModel(
                  title: 'A considered headline',
                  description: 'A concise story summary.',
                  urlToImage: null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A considered headline'), findsOneWidget);
    expect(find.text('A concise story summary.'), findsOneWidget);
    expect(find.text('FEATURED STORY'), findsOneWidget);
  });
}

Future<void> _pumpHome(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  await tester.pumpAndSettle(const Duration(milliseconds: 50));
}

class _FakeNewsRepository implements NewsRepository {
  final List<String> queries = [];

  @override
  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  }) async {
    queries.add(query ?? '');
    return const [
      ArticleModel(
        title: 'Offline-ready headline',
        description: 'A cached article preview.',
        urlToImage: null,
      ),
    ];
  }
}
