# Rebecca Johnson & Ethan Cole:     Ruby rsg.rb


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
    split_arr = raw_def.map{|x| x.sub(/>/, '>;')}       # substitute > for >; for easy split
    split_arr = split_arr.map{|x| x.strip}              # strip excess whitespace
    split_arr = split_arr.map{|x| x.split(/;/)}         # split based on semicolon
    split_arr = split_arr.map{|x| x.map{|x| x.strip}}
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
    ghash = Hash.new
    values = Array.new
    i = 0
    j = 1
    while i < split_def_array.length do
        while j < split_def_array[i].length do
            str = split_def_array[i][j]
            values = str.split(" ")
            #print values
            if ghash.keys.include? split_def_array[i][0]
                ghash[split_def_array[i][0]].push(values)
            else
                ghash[split_def_array[i][0]] = [values]
            end
            j += 1
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
    if (s.start_with?("<") and s.end_with?(">"))
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
    sentence = ""
    grammar[non_term].sample.each{|x|
        if is_non_terminal?(x)
            sentence += expand(grammar, x)
        else sentence += x + " " end
    }
    return sentence
end

# Given the name of a grammar file,
# read the grammar file and print a
# random expansion of the grammar
def rsg(filename)
    arr = read_grammar_defs(filename)
    splitArr = split_definition(arr)
    ghash = to_grammar_hash(splitArr)
    sentences = expand(ghash).gsub(/ (?=\.|,|'s |:|\)|\?|!|s )| (?<=\( )/, '').strip
    puts sentences
end

if __FILE__ == $0
    puts "What is the name of the grammar file?"
    STDOUT.flush
    name = gets.chomp
    rsg(name)
end
