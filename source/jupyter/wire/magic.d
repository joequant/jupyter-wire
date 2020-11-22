import jupyter.wire.kernel;
import jupyter.wire.log;
import std.typecons: tuple, Tuple;

abstract class Magic {
  string name;
  enum Type {Line, Cell};
  Type type;
  abstract ExecutionResult run(string command, string cell) @safe;
}

struct MagicRunner {
   Magic[string] cell_magic_map;
   Magic[string] line_magic_map;
   Tuple!(int, ExecutionResult) run(string command) @safe {
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
	auto c = matchFirst(i, regex(r"^%%([a-zA-Z0-9]+)\s*"));
	version(JupyterLogVerbose) log("cell magic ", c[1]);
	if (c[1] in cell_magic_map) {
	  return tuple(1, cell_magic_map[c[1]].run(i, cell_string));
	}
      }
      foreach (string i; line_items) {
	auto c = matchFirst(i, regex(r"^%([a-zA-Z0-9]+)\s*"));
	version(JupyterLogVerbose) log("line magic ", c[1]);
	if (c[1] in line_magic_map) {
	  return tuple(1, line_magic_map[c[1]].run(i, ""));
	}
      }
      return tuple(0,  textResult(""));
   }
   void register(Magic m) {
     if (m.type == Magic.Type.Line) {
       version(JupyterLogVerbose) log("adding line magic ", m.name);
       line_magic_map[m.name] = m;
     } else if (m.type == Magic.Type.Cell) {
       version(JupyterLogVerbose) log("adding cell magic ", m.name);
       cell_magic_map[m.name] = m;
     }
   }
}

static MagicRunner magic_runner;
