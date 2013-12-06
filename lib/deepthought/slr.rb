module DeepThought
  module DatalogParser
    module QUERY
      ACTIONS = [
                 {11 => [:shift, 4], 9 => [:shift, 6]},
                 {-1 => [:reduce, 0]},
                 {5 => [:shift, 8], 4 => [:shift, 9]},
                 {5 => [:reduce, 3], 4 => [:reduce, 3]},
                 {9 => [:shift, 6]},
                 {5 => [:reduce, 5], 4 => [:reduce, 5]},
                 {3 => [:shift, 11], 6 => [:shift, 12]},
                 {5 => [:reduce, 7], 4 => [:reduce, 7]},
                 {-1 => [:reduce, 1]},
                 {11 => [:shift, 4], 9 => [:shift, 6]},
                 {5 => [:reduce, 4], 4 => [:reduce, 4]},
                 {9 => [:shift, 15]},
                 {2 => [:shift, 18], 8 => [:shift, 19], 9 => [:shift, 20], 10 => [:shift, 21]},
                 {5 => [:reduce, 2], 4 => [:reduce, 2]},
                 {5 => [:reduce, 6], 4 => [:reduce, 6]},
                 {6 => [:shift, 12]},
                 {7 => [:shift, 22], 4 => [:shift, 23]},
                 {7 => [:reduce, 10], 4 => [:reduce, 10]},
                 {7 => [:reduce, 11], 4 => [:reduce, 11]},
                 {7 => [:reduce, 12], 4 => [:reduce, 12]},
                 {7 => [:reduce, 13], 4 => [:reduce, 13]},
                 {7 => [:reduce, 14], 4 => [:reduce, 14]},
                 {5 => [:reduce, 8], 4 => [:reduce, 8]},
                 {2 => [:shift, 18], 8 => [:shift, 19], 9 => [:shift, 20], 10 => [:shift, 21]},
                 {7 => [:reduce, 9], 4 => [:reduce, 9]}]

      GOTOS = [
               {:Query => [:goto, 1], :NMFAs => [:goto, 2], :NMFA => [:goto, 3], :MFA => [:goto, 5], :FA => [:goto, 7]},
               {},
               {},
               {},
               {:MFA => [:goto, 10], :FA => [:goto, 7]},
               {},
               {},
               {},
               {},
               {:NMFA => [:goto, 13], :MFA => [:goto, 5], :FA => [:goto, 7]},
               {},
               {:FA => [:goto, 14]},
               {:Ts => [:goto, 16], :T => [:goto, 17]},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {:T => [:goto, 24]},
               {}]

      GRAMMAR = [
                 [:prime, [[:nt, :Query]]],
                 [:Query, [[:nt, :NMFAs], [:t, 5]]],
                 [:NMFAs, [[:nt, :NMFAs], [:t, 4], [:nt, :NMFA]]],
                 [:NMFAs, [[:nt, :NMFA]]],
                 [:NMFA, [[:t, 11], [:nt, :MFA]]],
                 [:NMFA, [[:nt, :MFA]]],
                 [:MFA, [[:t, 9], [:t, 3], [:nt, :FA]]],
                 [:MFA, [[:nt, :FA]]],
                 [:FA, [[:t, 9], [:t, 6], [:nt, :Ts], [:t, 7]]],
                 [:Ts, [[:nt, :Ts], [:t, 4], [:nt, :T]]],
                 [:Ts, [[:nt, :T]]],
                 [:T, [[:t, 2]]],
                 [:T, [[:t, 8]]],
                 [:T, [[:t, 9]]],
                 [:T, [[:t, 10]]]]
    end

    module CLAUSES
      ACTIONS = [
                 {9 => [:shift, 4]},
                 {9 => [:shift, 4], -1 => [:reduce, 0]},
                 {9 => [:reduce, 2], -1 => [:reduce, 2]},
                 {5 => [:shift, 6], 3 => [:shift, 7]},
                 {6 => [:shift, 8]},
                 {9 => [:reduce, 1], -1 => [:reduce, 1]},
                 {9 => [:reduce, 3], -1 => [:reduce, 3]},
                 {11 => [:shift, 11], 9 => [:shift, 13]},
                 {2 => [:shift, 17], 8 => [:shift, 18], 9 => [:shift, 19], 10 => [:shift, 20]},
                 {5 => [:shift, 21], 4 => [:shift, 22]},
                 {5 => [:reduce, 6], 4 => [:reduce, 6]},
                 {9 => [:shift, 13]},
                 {5 => [:reduce, 8], 4 => [:reduce, 8]},
                 {3 => [:shift, 24], 6 => [:shift, 8]},
                 {5 => [:reduce, 10], 4 => [:reduce, 10]},
                 {7 => [:shift, 25], 4 => [:shift, 26]},
                 {7 => [:reduce, 13], 4 => [:reduce, 13]},
                 {7 => [:reduce, 14], 4 => [:reduce, 14]},
                 {7 => [:reduce, 15], 4 => [:reduce, 15]},
                 {7 => [:reduce, 16], 4 => [:reduce, 16]},
                 {7 => [:reduce, 17], 4 => [:reduce, 17]},
                 {9 => [:reduce, 4], -1 => [:reduce, 4]},
                 {11 => [:shift, 11], 9 => [:shift, 13]},
                 {5 => [:reduce, 7], 4 => [:reduce, 7]},
                 {9 => [:shift, 4]},
                 {5 => [:reduce, 11], 3 => [:reduce, 11], 5 => [:reduce, 11], 4 => [:reduce, 11]},
                 {2 => [:shift, 17], 8 => [:shift, 18], 9 => [:shift, 19], 10 => [:shift, 20]},
                 {5 => [:reduce, 5], 4 => [:reduce, 5]},
                 {5 => [:reduce, 9], 4 => [:reduce, 9]},
                 {7 => [:reduce, 12], 4 => [:reduce, 12]}]

      GOTOS = [
               {:Clauses => [:goto, 1], :Clause => [:goto, 2], :FA => [:goto, 3]},
               {:Clause => [:goto, 5], :FA => [:goto, 3]},
               {},
               {},
               {},
               {},
               {},
               {:NMFAs => [:goto, 9], :NMFA => [:goto, 10], :MFA => [:goto, 12], :FA => [:goto, 14]},
               {:Ts => [:goto, 15], :T => [:goto, 16]},
               {},
               {},
               {:MFA => [:goto, 23], :FA => [:goto, 14]},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {},
               {:NMFA => [:goto, 27], :MFA => [:goto, 12], :FA => [:goto, 14]},
               {},
               {:FA => [:goto, 28]},
               {},
               {:T => [:goto, 29]},
               {},
               {},
               {}]

      GRAMMAR = [
                 [:prime, [[:nt, :Clauses]]],
                 [:Clauses, [[:nt, :Clauses], [:nt, :Clause]]],
                 [:Clauses, [[:nt, :Clause]]],
                 [:Clause, [[:nt, :FA], [:t, 5]]],
                 [:Clause, [[:nt, :FA], [:t, 3], [:nt, :NMFAs], [:t, 5]]],
                 [:NMFAs, [[:nt, :NMFAs], [:t, 4], [:nt, :NMFA]]],
                 [:NMFAs, [[:nt, :NMFA]]],
                 [:NMFA, [[:t, 11], [:nt, :MFA]]],
                 [:NMFA, [[:nt, :MFA]]],
                 [:MFA, [[:t, 9], [:t, 3], [:nt, :FA]]],
                 [:MFA, [[:nt, :FA]]],
                 [:FA, [[:t, 9], [:t, 6], [:nt, :Ts], [:t, 7]]],
                 [:Ts, [[:nt, :Ts], [:t, 4], [:nt, :T]]],
                 [:Ts, [[:nt, :T]]],
                 [:T, [[:t, 2]]],
                 [:T, [[:t, 8]]],
                 [:T, [[:t, 9]]],
                 [:T, [[:t, 10]]]]
    end

    module_function

    def parse(tokens, mode)
      stack = [[0, nil]]
      token = tokens[0]
      tokens = tokens[1..-1]

      while true do
        state = stack[-1][0]
        action = mode::ACTIONS[state][token[0]]

        if action == nil then
          return false
        end

        if action[0] == :shift then
          stack << [action[1], token[1]]
          token, tokens = tokens[0], tokens[1..-1]
        elsif action[0] == :reduce then
          rule_num = action[1]
          name, prod = mode::GRAMMAR[rule_num]

          found = stack.pop(prod.length)

          if rule_num == 0 then
            return found[0][1]
          end

          next_state = mode::GOTOS[stack[-1][0]][name][1]

          stack << [next_state, [rule_num, found.map {|_,s| s} ]]
        end

      end

    end

    def construct_query(ast)
      if ast[0] == 1 then
        return construct_query(ast[1][0])
      elsif ast[0] == 2 then
        return construct_query(ast[1][0]) + [construct_query(ast[1][2])]
      elsif ast[0] == 3 then
        return [construct_query(ast[1][0])]
      elsif ast[0] == 4 then
        return [false] + construct_query(ast[1][1])
      elsif ast[0] == 5 then
        return [true] + construct_query(ast[1][0])
      elsif ast[0] == 6 then
        return [ast[1][0]] + construct_query(ast[1][2])
      elsif ast[0] == 7 then
        return [nil] + construct_query(ast[1][0])
      elsif ast[0] == 8 then
        args = construct_query(ast[1][2])
        return [(ast[1][0] + "/" + args.length.to_s).to_sym, args]
      elsif ast[0] == 9 then
        return construct_query(ast[1][0]) + [construct_query(ast[1][2])]
      elsif ast[0] == 10 then
        return [construct_query(ast[1][0])]
      elsif ast[0] == 11 then
        return ast[1][0]
      elsif ast[0] == 12 then
        return [:var, ast[1][0].to_sym]
      elsif ast[0] == 13 then
        return ast[1][0].to_sym
      elsif ast[0] == 14 then
        return ast[1][0].to_i
      end
    end

    def parse_query(tokens)
      ast = parse(tokens, QUERY)
      if ast == false then
        return false
      end

      return construct_query(ast)
    end

    def construct_clauses(ast)
      if ast[0] == 1 then
        return construct_clauses(ast[1][0]) + [construct_clauses(ast[1][1])]
      elsif ast[0] == 2 then
        return [construct_clauses(ast[1][0])]
      elsif ast[0] == 3 then
        return [construct_clauses(ast[1][0]), []]
      elsif ast[0] == 4 then
        return [construct_clauses(ast[1][0]), construct_clauses(ast[1][2])]
      elsif ast[0] == 5 then
        return construct_clauses(ast[1][0]) + [construct_clauses(ast[1][2])]
      elsif ast[0] == 6 then
        return [construct_clauses(ast[1][0])]
      elsif ast[0] == 7 then
        return [false] + construct_clauses(ast[1][1])
      elsif ast[0] == 8 then
        return [true] + construct_clauses(ast[1][0])
      elsif ast[0] == 9 then
        return [ast[1][0]] + construct_clauses(ast[1][2])
      elsif ast[0] == 10 then
        return [nil] + construct_clauses(ast[1][0])
      elsif ast[0] == 11 then
        args = construct_clauses(ast[1][2])
        return [(ast[1][0] + "/" + args.length.to_s).to_sym, args]
      elsif ast[0] == 12 then
        return construct_clauses(ast[1][0]) + [construct_clauses(ast[1][2])]
      elsif ast[0] == 13 then
        return [construct_clauses(ast[1][0])]
      elsif ast[0] == 14 then
        return ast[1][0]
      elsif ast[0] == 15 then
        return [:var, ast[1][0].to_sym]
      elsif ast[0] == 16 then
        return ast[1][0].to_sym
      elsif ast[0] == 17 then
        return ast[1][0].to_i
      end
    end

    def parse_clauses(tokens)
      if tokens == [[-1, nil]]
        return []
      end

      ast = parse(tokens, CLAUSES)
      if ast == false then
        return false
      end

      return construct_clauses(ast)
    end

  end

end
