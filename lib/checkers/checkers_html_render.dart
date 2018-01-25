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


	CheckersHtml() {
		print("Starting");
	}

	TableCellElement GetTableElement(int x, int y) {
		return querySelector("td[data-checkers-location='${y}_${x}']");
	}

	void Highlight(int x, int y) {
		GetTableElement(x,y).classes.add("highlight");
	}

	/// Remove all highlighting
	void UnHighlightAll() {
		querySelectorAll("td.highlight").forEach(
				(Element e) {
					e.classes.remove("highlight");
				});
	}

	void Colorize() {
		var allitems = querySelectorAll("td[data-checkers-location]");

		print("colorizing");
		if (allitems.length < 8 * 8) {
			return; // don't have the list yet
		}

		for (int i = 0; i < 8; i++) {
			bool pattern = i % 2 == 0;
			for (int j = 0; j < 8; j++) {
				var toColor = GetTableElement(i,j);
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
		this.UnHighlightAll();
		print("selecting ${x},${y}");
		Position position = CheckersBoard.Pos(x, y);
		Square square = board.GetSquare(position);
		if(CheckersBoard.isPiece(square)) {
			var actions = board.GetAllActions(position);

			void DoHighlight(Direction d, Action a) {
				if (a == Action.Move) {
					Position rel = CheckersBoard.relativeTo(d, position);
					this.Highlight(rel.x, rel.y);
				}
			}
			actions.forEach(DoHighlight);
		}
	}

	@override
	ngAfterViewChecked() {
		this.Colorize();
	}

	String combine(int x, int y) {
		return "${x}_${y}";
	}

	void Restart() {
		print("restarting");
		board.Restart();
	}

	isRed(a) => CheckersBoard.isRed(a);
	isBlack(a) => CheckersBoard.isBlack(a);
	isStacked(a) => CheckersBoard.isStacked(a);
	isPiece(a) => CheckersBoard.isPiece(a);
}
