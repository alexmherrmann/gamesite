import 'dart:html';

import 'package:angular2/core.dart';

import 'checkers.dart';

@Component(
	selector: "checkers-html",
	templateUrl: "checkers_board.html",
	styleUrls: const ["checkers.css"]
)
class CheckersHtml implements AfterViewChecked {
	@Input()
	CheckersBoard board;

//  CheckersHtmlBoardWrapper outputBoard;


	static const evenPattern = const [1, 0, 1, 0, 1, 0, 1, 0];
	static const oddPattern = const [0, 1, 0, 1, 0, 1, 0, 1];

	void Colorize() {
		var allitems = querySelectorAll("td[data-checkers-location]");

		print("colorizing");
		if (allitems.length < 8 * 8) {
			return; // don't have the list yet
		}

		for (int i = 0; i < 8; i++) {
			bool pattern = i % 2 == 0;
			for (int j = 0; j < 8; j++) {
				var toColor = querySelector(
					"td[data-checkers-location='${i}_${j}']");
				if (toColor == null) {
					throw new StateError(
						"Could not find the td with location ${i}_${j}}");
				}
				toColor.classes.removeAll(["darkback", "lightback"]);
				String value;

				value = pattern ? "darkback" : "lightback";

				toColor.classes.add(value);
				pattern = !pattern;
			}
		}
	}

	void Select(int x, int y) {
		print("selecting ${x},${y}");
		if (board.isPiece(board.GetSquare(CheckersBoard.Pos(x, y))));
	}

	@override
	ngAfterViewChecked() {
		this.Colorize();
	}

	String combine(int i, int j) {
		return "${i}_${j}";
	}

	restart() {
		print("restarting");
		board.Restart();
	}
}
