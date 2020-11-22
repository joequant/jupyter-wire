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
      auto line_regex = regex(r"^%([a-zA-Z0-9]+)\s*");
      auto cell_regex = regex(r"^%%([a-zA-Z0-9]+)\s*");
      foreach (string i; splitLines(command)) {
         auto m_line = matchFirst(i, line_regex);
      	 if(m_line) {
	 }
         auto m_cell = matchFirst(i, cell_regex);
	 if(m_cell) {
	 }
      }
   }
   void register(Magic m) {
   	magic_map[m.name] = m;
   }
}

static MagicRunner magic_runner;
