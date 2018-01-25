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

class GameOptions {
	bool makeForceJump = false;
}

enum State {
	/// It's red's turn
	RedTurn,
	/// Red MUST jump 
	RedForceJumpTurn,
	/// Black turn
	BlackTurn,
	/// Black MUST jump
	BlackForceJumpTurn,

	/// Game is finished
	Done
}


/// Helper class
class Position {
	int x = -1;
	int y = -1;
}


class NoSuchSquareException extends ArgumentError {
	NoSuchSquareException(String msg) : super(msg);
}

class CannotPerformActionException extends ArgumentError {
	CannotPerformActionException(String msg) : super(msg);
}

class CheckersBoard {

	GameOptions _options;

	int red = 12;
	int black = 12;
	/// Useless fluff
	String name = "2-person checkers!";

	/// Keeps track of the board
	List<List<Square>> board;

	void _setup() {
		this.board = new List<List<Square>>(8);
		for (int i = 0; i < 8; i++) {

			this.board[i] = new List<Square>(8);
			for (int j = 0; j < 8; j++) {
				this.board[i][j] = Square.Empty;
			}
		}
	}

	/// Initialize the board
	CheckersBoard() {
		this._setup();
	}

	CheckersBoard(GameOptions options) {
		this.options = options;
		this._setup();
	}

	/// Set the square at the position
	void SetSquare(Position position, Square square) {
		// TODO: change this to use one of the logic function

		// Check we're not trying to set something as an edge square
		if(square == Square.Edge) {
			throw new ArgumentError("Cannot set a square to be empty");
		}

		// If it isn't a nonexistant position...
		if(this.GetSquare(position) != Square.Edge) {
			// set it!
			this.board[position.x][position.y] = square;
		}
	}

	void DoAction(Position position, Direction direction, Action action) {
		// first check that the action is viable
		Action actionInDirection = this.GetPossibleAction(position, direction);
		Position inDirection = relativeTo(direction, position);
		Position inFurther = relativeTo(direction, inDirection);
		Square thisSquare = this.GetSquare(position);

		if(actionInDirection == action) {
			switch(action) {
				case Action.Move:
					this.SetSquare(position, Square.Empty);
					this.SetSquare(inDirection, thisSquare);
					break;
				case Action.Jump:
					this.SetSquare(position, Square.Empty);
					this.SetSquare(inDirection, Square.Empty);
					this.SetSquare(inFurther, thisSquare);

					if(isRed(thisSquare)) this.black--;
					else this.red--;
					break;
				case Action.Nothing:
					break;
				case Action.NotPiece:
					throw new CannotPerformActionException("NotPiece is not an action!");
				default:
					throw new ArgumentError("NOT IMPLEMENTED");
			}
		} else {
			throw new CannotPerformActionException("Cannot perform given action");
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

	/// Get whatever action is possible in the specified direction
	Action GetPossibleAction(Position position, Direction direction) {
		Square original = this.GetSquare(position);

		if (!isPiece(original)) {
			return Action.NotPiece;
		}

		Position lookAt = relativeTo(direction, position);

		Square inDirection = this.GetSquare(lookAt);

		if (isEmpty(inDirection)) {
			if (!isTowardsHome(original, direction) && !isStacked(original))
				return Action.Move;
			return Action.Nothing;
		}

		if (isSameColor(original, inDirection)) {
			return Action.Nothing;
		}

		if (!isSameColor(original, inDirection)) {
			Square possibleJump =
				this.GetSquare(relativeTo(direction, lookAt));

			if(isEmpty(possibleJump) && !isTowardsHome(possibleJump, direction)) {
				return Action.Jump;
			}
			return Action.Nothing;
		}
	}

	/// Perform a move
	bool Move(Position p, Direction d) {
		if (isPiece(GetSquare(p))) {

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
			var actions = {
				Direction.DownLeft: this.GetPossibleAction(
					p, Direction.DownLeft),
				Direction.DownRight: this.GetPossibleAction(
					p, Direction.DownRight),
				Direction.UpLeft: this.GetPossibleAction(p, Direction.UpLeft),
				Direction.UpRight: this.GetPossibleAction(p, Direction.UpRight)
			};
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
				lookAt.y = p.y + 1;
				break;
			case Direction.DownRight:
				lookAt.x = p.x + 1;
				lookAt.y = p.y + 1;
				break;
			case Direction.UpLeft:
				lookAt.x = p.x - 1;
				lookAt.y = p.y - 1;
				break;
			case Direction.UpRight:
				lookAt.x = p.x + 1;
				lookAt.y = p.y - 1;
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

	/// Is a red piece
	static bool isRed(Square s) => s == Square.Red || s == Square.RedStacked;

	/// Is a black piece
	static bool isBlack(Square s) => s == Square.Black || s == Square.BlackStacked;

	/// Is a stacked piece
	static bool isStacked(Square s) =>
		s == Square.RedStacked || s == Square.BlackStacked;

	/// Is any piece!
	static bool isPiece(Square s) => isRed(s) || isBlack(s);

	/// At the edge?
	static bool isEdge(Square s) => s == Square.Edge;

	/// Is the square empty
	static bool isEmpty(Square s) => s == Square.Empty;

	/// Are two squares the same color?
	static bool isSameColor(Square s1, Square s2) =>
		isRed(s1) == isRed(s2); // could be isBlack() just as easily


	// action helpers
	/// Is the thing given an action we can actually execute on
	static bool canDoSomething(Action a) =>
		a == Action.Jump ||
			a == Action.Move;


	/// This assumes that red starts at the bottom and vice-versa for black
	static bool isTowardsHome(Square s, Direction d) {
		if(isRed(s)) {
			return d == Direction.DownLeft || d == Direction.DownRight;
		} else if (isBlack(s)) {
			return d == Direction.UpLeft || d == Direction.UpRight;

		}
	}


}
