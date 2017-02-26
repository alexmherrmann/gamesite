/// Keep track of the state of a square
enum Square {
	Empty,
	Red,
	RedStacked,
	Black,
	BlackStacked,
	/// unused for now
	Edge,
}

/// A direction
enum Direction {
	UpRight,
	UpLeft,
	DownRight,
	DownLeft
}

enum Action {
	/// Can jump a piece (move 2)
	Jump,
	/// Can do nothing
	Nothing,
	/// Can move
	Move,
	/// Not a piece
	NotPiece
}


/// Helper class
class Position {
	int x = -1;
	int y = -1;
}


class NoSuchSquareException extends ArgumentError {
	NoSuchSquareException(String msg) : super(msg);
}

class CheckersBoard {
	/// Useless fluff
	String name = "2-person checkers!";

	/// Keeps track of the board
	List<List<Square>> board;

	/// Initialize the board
	CheckersBoard() {
		this.board = new List<List<Square>>(8);
		for (int i = 0; i < 8; i++) {
			this.board[i] = new List<Square>(8);
			for (int j = 0; j < 8; j++) {
				this.board[i][j] = Square.Empty;
			}
		}
	}

	/// Get the square for a position
	Square GetSquare(Position p) {
		if (p.x > 8) {
			return Square.Edge;
		} else if (p.x < 0) {
			return Square.Edge;
		}

		if (p.y > 8) {
			return Square.Edge;
		} else if (p.y < 0) {
			return Square.Edge;
		}

		return this.board[p.y][p.x];
	}

	/// Helper to turn x/y into position
	static Position Pos(int x, int y) {
		Position p = new Position();
		p.x = x;
		p.y = y;
		return p;
	}

	/// Set a square at a position to a value
	void SetSquare(Position p, Square s) {
		this.board[p.y][p.x] = s;
	}

	/// Get whatever action is possible in the specified direction
	Action GetPossibleAction(Position position, Direction direction) {
		Square original = this.GetSquare(position);

		if (!isPiece(original)) {
			return Action.NotPiece;
		}

		Position lookAt = relativeTo(direction, position);

		Square inDirection = this.GetSquare(lookAt);
		if (isPiece(inDirection)) {
			return Action.Nothing;
		}

		if (isRed(original)) {
			if (isRed(inDirection)) {
				return Action.Nothing; // blocked
			} else if (isBlack(inDirection)) {
				Square possibleBlock = this.GetSquare(
					relativeTo(direction, lookAt));
				if (possibleBlock == Square.Empty) {
					return Action.Jump;
				}
			}
		} else if (original == Square.Black) {

		}
	}

	/// Return a map of actions for each 4 directions
	Map<Direction, Action> GetAllActions(Position p) {
		if (!isPiece(GetSquare(p))) {
			const actions = const {
				Direction.DownLeft: Action.Nothing,
				Direction.DownRight: Action.Nothing,
				Direction.UpLeft: Action.Nothing,
				Direction.UpRight: Action.Nothing
			};
			return actions;
		} else {
//			var actions = {
//				Direction.DownLeft: this.GetPossibleAction(
//					p, Direction.DownLeft),
//				Direction.DownRight: this.GetPossibleAction(
//					p, Direction.DownRight),
//				Direction.UpLeft: this.GetPossibleAction(p, Direction.UpLeft),
//				Direction.UpRight: this.GetPossibleAction(p, Direction.UpRight)
//			};
			var DownLeft = this.GetPossibleAction(p, Direction.DownLeft);
			var DownRight = this.GetPossibleAction(p, Direction.DownRight);
			var UpLeft = this.GetPossibleAction(p, Direction.UpLeft);
			var UpRight = this.GetPossibleAction(p, Direction.UpRight);

			var actions = new Map<Direction, Action>();

			actions[Direction.DownLeft] = DownLeft;
			actions[Direction.DownRight] = DownRight;
			actions[Direction.UpLeft] = UpLeft;
			actions[Direction.UpRight] = UpRight;
			return actions;
		}
		return null;
	}

	/// Get the position relative to another in a specific direction
	static Position relativeTo(Direction d, Position p) {
		Position lookAt = new Position();
		switch (d) {
			case Direction.DownLeft:
				lookAt.x = p.x - 1;
				lookAt.y = p.y - 1;
				break;
			case Direction.DownRight:
				lookAt.x = p.x + 1;
				lookAt.y = p.y - 1;
				break;
			case Direction.UpLeft:
				lookAt.x = p.x - 1;
				lookAt.y = p.y + 1;
				break;
			case Direction.UpRight:
				lookAt.x = p.x + 1;
				lookAt.y = p.y + 1;
				break;
			default:
				throw new Exception("wat");
		}
		return lookAt;
	}

	Restart() {
		for (int y = 0; y < 3; y++) {
			bool place = false;
			if (y % 2 == 0) {
				place = true;
			}

			for (int x = 0; x < 8; x++) {
				Position p = Pos(x, y);
				if (place) {
					SetSquare(p, Square.Black);
				}
				place = !place;
			}
		}

		for (int y = 7; y > 7 - 3; y--) {
			bool place = false;
			if (y % 2 == 0) {
				place = true;
			}

			for (int x = 0; x < 8; x++) {
				Position p = Pos(x, y);
				if (place) {
					SetSquare(p, Square.Red);
				}
				place = !place;
			}
		}
	}

	//piece helpers

	/// is a red piece
	static bool isRed(Square s) => s == Square.Red || s == Square.RedStacked;

	/// is a black piece
	static bool isBlack(Square s) => s == Square.Black || s == Square.BlackStacked;

	/// is a stacked piece
	static bool isStacked(Square s) =>
		s == Square.RedStacked || s == Square.BlackStacked;

	/// is any piece!
	static bool isPiece(Square s) => isRed(s) || isBlack(s);

	/// Are two squares the same color?
	static bool isSameColor(Square s1, Square s2) =>
		isRed(s1) == isRed(s2); // could be isBlack() just as easily


	// action helpers
	/// is the thing given an action we can actually execute on
	static bool canDoSomething(Action a) =>
		a == Action.Jump ||
			a == Action.Move;


}
