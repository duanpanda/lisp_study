// Game Dice of Doom

// #if !defined RYAN_DEBUG
// #define RYAN_DEBUG
// #endif

#include <iostream>
#include <vector>
#include <ctime>
#include <cstdlib>
using namespace std;

const int g_num_players = 2;
const int g_max_dice = 3;
const int g_board_size = 2;
const int g_board_hexnum = g_board_size * g_board_size;

inline int random_num(int n)
{
  return rand() % n;
}

struct Hexagon
{
  int player_index;
  int dice_num;

  Hexagon(int i, int d) : player_index(i), dice_num(d) {}
#if defined RYAN_DEBUG
  void print() const;
#endif
  void draw() const;
  char player_letter() const { return 97 + player_index; }
};

#if defined RYAN_DEBUG
void Hexagon::print() const
{
  cout << "(" << player_index << " " << dice_num << ")";
}
#endif

void Hexagon::draw() const
{
  cout << player_letter() << "-" << dice_num;
}

class Board
{
public:
#if defined RYAN_DEBUG
  void print() const;
#endif
  void add_hex(const Hexagon& hex);
  void draw() const;

  vector<Hexagon> v;
};

#if defined RYAN_DEBUG
void Board::print() const
{
  cout << "#(";
  unsigned int i;
  for (i = 0; i < v.size() - 1; ++i) {
    v[i].print();
      cout << " ";
  }
  v[i].print();                 // i==b.size()-1
  cout << ")\n";
}
#endif

void Board::add_hex(const Hexagon& hex)
{
  v.push_back(hex);
}

void Board::draw() const
{
  // loop row by row
  for (int y = 0; y < g_board_size; ++y) {
    cout << "\n";               // fresh line

    // indent
    for (int i = 0; i < g_board_size - y; i++) {
      cout << " ";
    }
    // loop column by column
    for (int x = 0; x < g_board_size; ++x) {
      int j = x+g_board_size*y;
      v[j].draw();
      cout << " ";
    }
  }
  cout << endl;
}

struct Game_env
{
  Board board;
  int cur_player;               // who's turn now

  Game_env();
};

Game_env::Game_env() : cur_player(0)
{
  // generate board
  for (int i = 0; i < g_board_hexnum; ++i) {
    board.add_hex(Hexagon(random_num(g_num_players), 1+random_num(g_max_dice)));
  }
}

bool is_neighbor(const Board& board, int src, int dst)
{
  int up = src - g_board_size;
  int down = src + g_board_size;
  
}

bool is_valid_move(const Game_env& env, const Hexagon& hex_src,
                   const Hexagon& hex_dst, int src,
                   int dst, int cur_player)
{
  return (cur_player == hex_src.player_index &&
          is_neighbor(env.board, src, dst) &&
          hex_src.dice_num > hex_dst.dice_num);
}

int attack(Game_env& env, Hexagon& hex_src, Hexagon& hex_dst, int cur_player)
{
  int spare_dice = hex_src.dice_num - 1;
  hex_src.dice_num = 1;
  int took = hex_dst.dice_num;
  hex_dst.dice_num = spare_dice;
  hex_dst.player_index = cur_player;
  return took;
}

void reinforcement(Board& board, int took_num)
{
  for (int i = 0; i < board.v.size() && took_num > 0; ++i) {
    ++board.v[i].dice_num;
    --took_num;
  }
}

void annouce_invalid_move()
{
  cout << "Invalid move!\n";
}

void move(Game_env& env, int src, int dst, int cur_player)
{
  Board& b = env.board;
  Hexagon& hex_src = b.v[src];
  Hexagon& hex_dst = b.v[dst];
  if (is_valid_move(env, hex_src, hex_dst, src, dst, cur_player)) {
    int took_num = attack(env, hex_srd, hex_dst, cur_player);
    reinforcement(b, took_num);
  }
  else
    annouce_invalid_move();
}

int main()
{
  srand(time(0));
  Game_env env;
#if defined RYAN_DEBUG
  env.board.print();
#endif
  env.board.draw();

  int cur_player = 0;

  while (cin) {
    int src = 0;
    int dst = 0;
    cout << "Please input a move in this format \"a b\":\n";
    cin >> src >> dst;
    move(env, src, dst, cur_player);
  }

  return 0;
}
