module DeepThought

  module DatalogLexer
    module CODE
      START = 0

      MATCH = {
        0=> [],
        1=> [0],
        2=> [8],
        3=> [9],
        4=> [10],
        5=> [1],
        6=> [2],
        7=> [3],
        8=> [4],
        9=> [5],
        10=> [6],
        11=> [7]}

      DFA = {
        0=> {0=> 1, 1=> 5, 2=> 6, 3=> 7, 4=> 8, 5=> 9, 6=> 10, 7=> 11, 8=> 2, 9=> 3, 10=> 4},
        1=> {0=> 1},
        2=> {8=> 2, 9=> 2, 10=> 2},
        3=> {8=> 3, 9=> 3, 10=> 3},
        4=> {10=> 4},
        5=> {},
        6=> {},
        7=> {},
        8=> {},
        9=> {},
        10=> {},
        11=> {}}
    end


    module QUOTE
      START = 1

      MATCH = {
        0=> [],
        1=> [],
        2=> [0]}

      DFA = {
        0=> {0=> 1, 1=> 1, 2=> 1},
        1=> {0=> 2, 1=> 0, 2=> 1},
        2=> {}}
    end


    CODE_MAP = [-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,-1,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,-1,2,-1,-1,-1,-1,1,6,7,-1,-1,4,-1,5,-1,10,10,10,10,10,10,10,10,10,10,3,-1,-1,-1,-1,-1,-1,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,-1,-1,-1,-1,8,-1,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,-1,-1,-1,-1,-1]

    SINGLE_QUOTE_MAP = [-1,-1,-1,-1,-1,-1,-1,-1,-1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,-1]

    DOUBLE_QUOTE_MAP = [-1,-1,-1,-1,-1,-1,-1,-1,-1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,-1]


    MODE = [[CODE, CODE_MAP],
            [QUOTE, SINGLE_QUOTE_MAP],
            [QUOTE, DOUBLE_QUOTE_MAP]]


    module_function
    def next_mode(match, mode)
      if match == 1 and mode == 0 then
        return 1
      elsif match == 2 and mode == 0 then
        return 2
      elsif match == 0 and mode > 0 then
        return 0
      else
        return mode
      end
    end


    def finish(state, dfa)
      match = dfa::MATCH.fetch(state, [])

      if match.length == 0 then
        return -1
      else
        return match[0]
      end
    end


    def tokens(s, found, state, mode)
      result = []

      while s.length > 0 do
        char = s[0]

        dfa, charmap = MODE[mode]
        code = char.codepoints[0]
        code = (code>127) ? -1 : charmap[code]

        next_state = dfa::DFA.fetch(state, {}).fetch(code, -1)

        if next_state >= 0 then
          found += char
          state = next_state
          s = s[1..-1]
        else
          match = finish(state, dfa)

          if match < 0 then
            return [false, mode, found]
          end

          result << [mode, match, found]

          mode = next_mode(match, mode)
          found = ""
          state = MODE[mode][0]::START
        end
      end

      match = finish(state, dfa)

      if match < 0 then
        return [false, mode, found]
      end

      result << [mode, match, found]
      return [true, result]
    end


    def convert_tokens(tokens)
      result = []

      tokens.each do |mode, match, s|
        if mode == 0 and [0,1,2].include?(match) then
          next
        end

        if mode == 0
          if match === 9 and s === "not" then
            result << [11, s]
          else
            result << [match, s]
          end
        elsif mode == 1
          result << [9, s[0..-2]]
        elsif mode == 2
          result << [2, s[0..-2]]
        end
      end

      result << [-1, nil]
      return result
    end


    def tokenize(s)
      result = tokens(s, "", MODE[0][0]::START, 0)

      if result[0] then
        return [true, convert_tokens(result[1])]
      else
        return result
      end
    end

  end

end
