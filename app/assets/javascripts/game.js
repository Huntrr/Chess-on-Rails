function goAndPlay() {
  $(document).ready(function() {
    var board,
    boardEl = $('#board'),
      game = new Chess(),
      squareToHighlight,
    statusEl = $('#status'),
      status2El = $('#status2'),
      pgnEl = $('#pgn');

    var sendingMove = false;
    var sendingSandbox = false;

    var removeHighlights = function(color) {
      boardEl.find('.square-55d63').removeClass('highlight-' + color);
    };

    // do not pick up pieces if the game is over
    // only pick up pieces for White if white
    // only pick up pieces for black if black
    var onDragStart = function(source, piece, position, orientation) {
      if(!s_sandbox) {
        if (game.in_checkmate() === true || game.in_draw() === true ||
            (s_side === "white" && piece.search(/^b/) !== -1) || (s_side === "black" && piece.search(/^w/) !== -1) || !s_playing) {
          return false;
        }
      }
    };

    $('#undo').click(function() {
      if(s_undos && !s_sandbox) {
        game.undo();
        board.position(game.fen());
        removeHighlights('black');
        removeHighlights('white');

        updateStatus();

        sendPos();
      }
    });

    $('#flip').click(function() {
      board.flip();
    });

    var onDrop = function(source, target, piece, newPos, oldPos, orientation) {
      sendingSandbox = true;
      if(!s_sandbox) {
        // see if the move is legal
        var move = game.move({
          from: source,
          to: target,
          promotion: 'q'
        });

        // illegal move
        if (move === null) return 'snapback';
      }

      // highlight white's move
      if(game.turn() === 'w') {
        removeHighlights('black');
        boardEl.find('.square-' + source).addClass('highlight-black');
        boardEl.find('.square-' + target).addClass('highlight-black');
      } else if(game.turn() === 'b') {
        removeHighlights('white');
        boardEl.find('.square-' + source).addClass('highlight-white');
        boardEl.find('.square-' + target).addClass('highlight-white');
      }

      updateStatus();
      if(s_sandbox) {
        sendSpecPos(ChessBoard.objToFen(newPos))
      } else {
        sendPos();
      }
    };

    var onMoveEnd = function() {
      boardEl.find('.square-' + squareToHighlight).addClass('highlight-black');
    };

    // update the board position after the piece snap
    // for castling, en passant, pawn promotion
    var onSnapEnd = function() {
      if(!s_sandbox) {
        board.position(game.fen());
      }

    };


    var updateStatus = function() {
      var status = '';

      var moveColor = 'White';
      if (game.turn() === 'b') {
        moveColor = 'Black';
      }

      // checkmate?
      if (game.in_checkmate() === true) {
        status = 'Game over, ' + moveColor + ' is in checkmate.';
        if(game.turn() == 'b') {
          sendResult(1);
        } else {
          sendResult(-1);
        }
      }

      // draw?
      else if (game.in_draw() === true) {
        status = 'Game over, drawn position';
        sendResult(2);
      }

      // stalemate?
      else if (game.in_stalemate() === true) {
        status = 'Game over, stalemated position';
        sendResult(3);
      }

      // insufficient material?
      else if (game.insufficient_material() === true) {
        status = 'Game over, drawn position due to insufficient material';
        sendResult(4);
      }

      // game still on
      else {
        status = moveColor + ' to move';

        // check?
        if (game.in_check() === true) {
          status += ', ' + moveColor + ' is in check';
        }
        sendResult(0);
      }

      if(s_sandbox) {
        status = "Sandbox mode";
        sendResult(0);
      }

      statusEl.html(status);
      status2El.html(status);
      pgnEl.html(game.pgn());
    };

    var loadFromPGN = function(pgn) {
      game.load_pgn(pgn);

      return game.fen();
    };

    var sendPos = function() {
      sendingMove = true;
      $.ajax({
        url: window.location.pathname,
        data: {game: {game_state: (!s_sandbox ? game.pgn() : board.fen()) }},
        type: 'patch',
        dataType: 'json',
        success: function(data) {
          sendingMove = false;
        }
      });
    }

    var sendSpecPos = function(position) {
      sendingMove = true;
      $.ajax({
        url: window.location.pathname,
        data: {game: {game_state: position }},
        type: 'patch',
        dataType: 'json',
        success: function(data) {
          sendingMove = false;
        }
      });
    }

    var sendResult = function(res) {
      sendingMove = true;
      $.ajax({
        url: window.location.pathname,
        data: {game: {result: res}},
        type: 'patch',
        dataType: 'json',
        success: function(data) {
          sendingMove = false;
        }
      });
    }

    var updateBoard = function(pgn) {
      if(pgn == game.pgn()) {
        return; // do nothing
      } else {
        var n_array = pgn.split(" ");
        var o_array = n_array.slice(0);
        o_array.pop();

        var oneStepBack = o_array.join(" ");

        if(oneStepBack == game.pgn()) {
          //Everyone is playing fair
          var notation = n_array[n_array.length - 1];
          var move = game.move(notation);

          //Highlight
          var source = move["from"];
          var target = move["to"];

          if(game.turn() === 'b') {
            removeHighlights('black');
            boardEl.find('.square-' + source).addClass('highlight-black');
            boardEl.find('.square-' + target).addClass('highlight-black');
          } else if(game.turn() === 'b') {
            removeHighlights('white');
            boardEl.find('.square-' + source).addClass('highlight-white');
            boardEl.find('.square-' + target).addClass('highlight-white');
          }
        }
      }
      board.position(loadFromPGN(pgn));
      updateStatus();
    }

    var getPos = function() {
      $.ajax({
        url: window.location.pathname,
        type: 'get',
        dataType: 'json',
        success: function(data)
        {
          console.log("Got data: ");
          console.log(data);
          if(!sendingMove) {
            if(!s_sandbox) {
              s_pos = data['game_state'];
              updateBoard(data['game_state']);
            } else {
              s_pos = data['game_state'];
              board.position(data['game_state']);
            }
          }
        } 
      });
    }


    var cfg = {
      draggable: true,
      position: (s_pos === '' ? 'start' : loadFromPGN(s_pos)),
      onDragStart: onDragStart,
      onDrop: onDrop,
      onMoveEnd: onMoveEnd,
      onSnapEnd: onSnapEnd,
      sparePieces: s_sandbox,
      dropOffBoard: (!s_sandbox ? 'snapback' : 'trash'),
      orientation: s_side
    };
    board = new ChessBoard('board', cfg);
    $(window).resize(board.resize);

    updateStatus();


    getPos();
    setInterval(getPos, 3000);
  });
}
