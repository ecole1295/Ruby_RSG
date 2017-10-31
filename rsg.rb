# Extracts just the definitions from the grammar file
# Returns an array of strings where each string is the lines for
# a given definition (without the braces)
def read_grammar_defs(filename)
  filename = 'grammars/' + filename unless filename.start_with? 'grammars/'
  filename += '.g' unless filename.end_with? '.g'
  contents = open(filename, 'r') { |f| f.read }
  contents.scan(/\{(.+?)\}/m).map do |rule_array|
    rule_array[0]
  end
end

# Takes data as returned by read_grammar_defs and reformats it
# in the form of an array with the first element being the
# non-terminal and the other elements being the productions for
# that non-terminal.
# Remember that a production can be empty (see third example)
# Example:
#   split_definition "\n<start>\nYou <adj> <name> . ;\nMay <curse> . ;\n"
#     returns ["<start>", "You <adj> <name> .", "May <curse> ."]
#   split_definition "\n<start>\nYou <adj> <name> . ;\n;\n"
#     returns ["<start>", "You <adj> <name> .", ""]
def split_definition(raw_def)
  # TODO: your implementation here
  expand = raw_def.map { |s| "#{s}"}.join
  expand = expand.gsub /\n/, '*'
  expand = expand.gsub /\s+/, ' '
  #expand = expand.gsub '*', '\n'

  split_def = expand.split(/\s*[;*]\s* /x)
  #split_def = split_def.each{ |x| arr = x.split(/[\r\n]+/)}
  #split_def = split_def.each {|x| arr = x.("\\n", " ")}
  #puts "SPLIT"
 # print split_def
  #rsg(split_def)

end

# Takes an array of definitions where the definitions have been
# processed by split_definition and returns a Hash that
# is the grammar where the key values are the non-terminals
# for a rule and the values are arrays of arrays containing
# the productions (each production is a separate sub-array)

# Example:
# to_grammar_hash([["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]])
# returns {"<start>"=>[["The", "<object>", "<verb>", "tonight."]], "<object>"=>[["waves"], ["big", "yellow", "flowers"], ["slugs"]], "<verb>"=>[["sigh", "<adverb>"], ["portend", "like", "<object>"], ["die", "<adverb>"]], "<adverb>"=>[["warily"], ["grumpily"]]}
def to_grammar_hash(split_def_array)
  # TODO: your implementation here
   ghash = Hash.new
   values = Array.new
   i = 0
   j = 1
   while i < split_def_array.length do
     while j < split_def_array[i].length do
       str = split_def_array[i][j]
       values = str.split(" ")
       print values
       if ghash.keys.include? split_def_array[i][0]
         ghash[split_def_array[i][0]] << values
       else
       ghash[split_def_array[i][0]] = values
       end
      j += 1
       puts " "
     end
     i += 1
     j = 1
   end
  return ghash
end

# Returns true iff s is a non-terminal
# a.k.a. a string where the first character is <
#        and the last character is >
def is_non_terminal?(s)
  # TODO: your implementation here
  if (s[0] == '<' && s[(s.length)-1] == '>')
    return true
else
  return false
    end
end

# Given a grammar hash (as returned by to_grammar_hash)
# returns a string that is a randomly generated sentence from
# that grammar
#
# Once the grammar is loaded up, begin with the <start> production and expand it to generate a
# random sentence.
# Note that the algorithm to traverse the data structure and
# return the terminals is extremely recursive.
#
# The grammar will always contain a <start> non-terminal to begin the
# expansion. It will not necessarily be the first definition in the file,
# but it will always be defined eventually. Your code can
# assume that the grammar files are syntactically correct
# (i.e. have a start definition, have the correct  punctuation and format
# as described above, don't have some sort of endless recursive cycle in the
# expansion, etc.). The names of non-terminals should be considered
# case-insensitively, <NOUN> matches <Noun> and <noun>, for example.

def expand(grammar, non_term="<start>")
  # TODO: your implementation here
  sentence = ""
  i = 0
  while i < grammar.length do
    if (grammar.keys[i] == non_term)
      index = i
    end
    i += 1
  end
  i = 0
  randomNum = rand(grammar[grammar.keys[index]].length)
  while i < grammar[grammar.keys[index]][randomNum].length do
    if (is_non_terminal?(grammar[grammar.keys[index]][randomNum][i]) == true)
      sentence += " "
      value =  expand(grammar, grammar[grammar.keys[index]][randomNum][i])
      sentence += value
      else
       sentence += grammar[grammar.keys[index]][randomNum][i] + " "
    end
    i+=1
  end
  return sentence
end

# Given the name of a grammar file,
# read the grammar file and print a
# random expansion of the grammar
def rsg(filename)
  # TODO: your implementation here
  puts "The filename is " + filename
  arr = read_grammar_defs(filename)
  #splitArr = split_definition(arr)
  splitArr = [["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]]
  ghash = to_grammar_hash(splitArr)
  #ghash = {"<start>"=>[["The", "<object>", "<verb>", "tonight."]], "<object>"=>[["waves"], ["big", "yellow", "flowers"], ["slugs"]], "<verb>"=>[["sigh", "<adverb>"], ["portend", "like", "<object>"], ["die", "<adverb>"]], "<adverb>"=>[["warily"], ["grumpily"]]}
  #Array of sentences? Fill array with expanded sentences?
 # sentences = expand(ghash)
  puts ghash
end

if __FILE__ == $0
  # TODO: your implementation of the following
  # prompt the user for the name of a grammar file
  # rsg that file
  puts "What is the name of the grammar file?"
  STDOUT.flush
  name = gets.chomp
  rsg(name)

end