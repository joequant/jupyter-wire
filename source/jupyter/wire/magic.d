import jupyter.wire.kernel;

abstract class Magic {
   string name;
   enum Type {Line, Cell};
   abstract void run(string command, string cell);
}

struct MagicRunner {
   Magic[string] magic_map;
   void run(string command) {
      import std.string;
      import std.regex;
      import std.array : join;
      auto line_regex = regex(r"^%([a-zA-Z0-9]+)\s*");
      auto cell_regex = regex(r"^%%([a-zA-Z0-9]+)\s*");
      string[] cell_string_array;
      string[] cell_items;
      string[] line_items;
      foreach (string i; splitLines(command)) {
         if(matchFirst(i, line_regex)) {
           line_items ~= i;
	 } else if(matchFirst(i, cell_regex)) {
	   cell_items ~= i;
	 } else {
	   cell_string_array ~= i;
	 }
      }
      auto cell_string = join(cell_string_array, "\n");
      foreach (string i; cell_items) {
      }
      foreach (string i; line_items) {
      }
   }
   void register(Magic m) {
   	magic_map[m.name] = m;
   }
}

static MagicRunner magic_runner;
