import 'dart:html';
import 'package:angular2_components/angular2_components.dart';
import 'package:angular2/core.dart';
import 'checkers.dart';

@Component(
  //language=HTML
  selector: "checkers-html",
    templateUrl: "checkers_board.html",
  //language=CSS
  styles: const [
    '''.htmlboard td {
    border: solid;
    width: 33px;
    height: 33px;
}''',
    '.lightback {background-color: beige}',
    '.darkback {background-color: #9B5D25}'
  ]
)

//enum Color {
//
//}
//class HtmlSquare {
//  Square contains;
//  Color squareColor;
//}
//class CheckersHtmlBoardWrapper {
//  List<List<HtmlSquare>>
//}
class CheckersHtml implements AfterViewChecked {
  @Input()
  CheckersBoard board;

//  CheckersHtmlBoardWrapper outputBoard;


  static const evenPattern = const [1,0,1,0,1,0,1,0];
  static const oddPattern = const [0,1,0,1,0,1,0,1];
  void Colorize() {
    var allitems = querySelectorAll("td[data-checkers-location]");

    print("colorizing");
    if(allitems.length < 8*8) {
      return; // don't have the list yet
    }

    for (int i = 0; i < 8; i++) {
      var pattern = i%2==0 ? evenPattern : oddPattern;
      for (int j = 0; j< 8; j++) {
        var toColor = querySelector("td[data-checkers-location='${i}_${j}']");
        if (toColor == null) {
          throw new StateError("Could not find the td with location ${i}_${j}}");
        }
        toColor.classes.removeAll(["darkback", "lightback"]);
        String value;
        if (pattern[j]==1) {
          value = "darkback";
        } else {
          value = "lightback";
        }
        toColor.classes.add(value);
      }
    }
  }

  CheckersHtml() {}

  @override
  ngAfterViewChecked() {
    this.Colorize();
  }

  combine(int i, int j) {
    return "${i}_${j}";
  }
  restart() {
    print("restarting");
    board.Restart();
  }
}
