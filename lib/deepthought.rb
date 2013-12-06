require_relative 'deepthought/dfa'
require_relative 'deepthought/slr'

module DeepThought

  module Datalog

    module SubstitutionMethods

      def method_missing(name)
        return subst([:var, name.to_sym])
      end

      def is_var(v)
        return ((v.instance_of? Array) and
                (v.length == 2) and
                (v[0] == :var))
      end

      def subst(key)
        while is_var(key) do
          found = false

          s = self

          while not s == Nil do
            if s.key == key
              key = s.value
              found = true
              break
            end

            s = s.parent
          end

          if not found
            break
          end
        end

        return key
      end

      def ext(key, value)
        v = subst(value)

        if is_var(v)
          if (key == v)
            return false
          end
        end

        return Substitution.new(self, key, value)
      end

      def unify(v1, v2)
        v1 = subst(v1)
        v2 = subst(v2)

        if is_var(v1)
          if is_var(v2) and (v1 == v2)
            return self
          end
          return ext(v1, v2)
        end

        if is_var(v2)
          return ext(v2, v1)
        end

        if (v1 == v2)
          return self
        end

        return false
      end

      def exts(list)
        list.inject(self) do |s,e|
          k, v = e
          s.ext(k, v)
        end
      end

      def walk(vs)
        vs.map do |v|
          subst(v)
        end
      end

      def items()
        Enumerator.new do |enum|
          s = self

          while not s == Nil do
            enum << [s.key, s.value]
            s = s.parent
          end
        end
      end
    end


    class Nil
      extend SubstitutionMethods
    end


    class Substitution
      include SubstitutionMethods

      def initialize(parent, key, value)
        @parent = parent
        @key = key
        @value = value
      end

      attr_accessor :parent, :key, :value
    end


    module_function


    def is_var(v)
      return ((v.instance_of? Array) and
              (v.length == 2) and
              (v[0] == :var))
    end


    def reified(v)
      if is_var(v)
        if v[1].is_a? Integer
          return true
        end
      end

      return false
    end


    def reify(vs, s=Nil, c=0)
      res = vs.map do |v|
        val = s.subst(v)

        if not Datalog.is_var(val)
          val
        elsif not val[1].instance_of? Symbol
          val
        else
          g = [:var, c]
          s = s.ext(val, g)
          c = c + 1
          g
        end
      end

      return res, s, c
    end


    def query(goals, db)
      posgoals = goals.select{|pos,x,y| pos == true}.map{|pos,x,y| [x,y]}
      neggoals = goals.select{|pos,x,y| pos == false}.map{|pos,x,y| [x,y]}

      s = Nil
      c = 0

      posgoals.each do |g|
        _, s, c = reify(g[1], s, c)
      end

      r = Nil.exts(s.items.map {|k,v| [v,k]})
      a = (0..c-1).map {|n| [:var, n]}

      table = {}
      table[[:root, a]] = [[], [], [], false]

      cont([ [ [[:rule, a.map {|x| r.subst(x)} , posgoals, neggoals]], :root, a ] ],
           table,
           db)

      answers, _ = table[[:root, a]]

      answers.map do |answer|
        ans = Nil.exts( (0..answer.count-1).map {|i| [[:var, i], answer[i]]} )
        Nil.exts(s.items.map {|k,v| [k, ans.subst(v)]} )
      end
    end


    def cont(stack, table, db)
      while true do
        while (stack.length > 0)
          top = stack.pop()

          if top[0].length == 0
            next
          end

          head, tail = top[0][0], top[0][1..-1]
          p = top[1]
          a = top[2]

          stack << [tail, p, a]
          waitings = []

          call(head, p, a, waitings, stack, table, db)
          proceed(waitings, stack, table, db)
        end

        active = []
        negtargets = []

        table.each_pair do |goal, frame|
          _,_,negs,completed = frame
          if (completed == true)
            next
          end

          active << goal

          negs.each do |parent, _|
            g, _ = parent
            if not negtargets.include?(g)
              negtargets << g
            end
          end
        end

        negreachable = trace(negtargets, table)
        completed = active.select {|g| not negreachable.include?(g)}

        completed.each do |goal|
          complete(goal, waitings, stack, table, db)
        end

        if negreachable.empty?
          return
        end

        if completed.empty?
          raise "negtive loop"
        end

        proceed(waitings, stack, table, db)

      end
    end

    def subst_of(answer)
      return Nil.exts((0..(answer.length-1)).map { |n| [[:var, n], answer[n]] })
    end


    def proceed(waitings, stack, table, db)
      while (waitings.length > 0)
        answer, frame = waitings.pop()
        parent, s, r, posgoals, neggoals = frame

        s1 = subst_of(answer)
        r1 = s.exts(r.items.map {|k,v| [k, s1.subst(v)]})
        success(parent, r1, posgoals, neggoals, waitings, stack, table, db)
      end
    end


    def poslookup(goal, frame, waitings, stack, table, db)
      entry = table[goal]

      if not entry == nil
        answers, poslookups, neglookups, completed = entry

        if not completed
          poslookups << frame
        end

        answers.each do |answer|
          waitings << [answer, frame]
        end

        return
      end

      table[goal] = [[], [frame], [], false]
      choices = db[goal[0]]

      stack << [choices] + goal
    end

    def neglookup(goal, frame, waitings, stack, table, db)
      entry = table[goal]

      if not entry == nil
        answers, poslookups, neglookups, completed = entry

        if not completed
          neglookups << frame
        end

        return
      end

      table[goal] = [[], [], [frame], false]
      choices = db[goal[0]]
      stack << [choices] + goal
    end

    def trace(found, table)
      delta = found.map {|g| g}

      while not delta.empty?
        nextdelta = []

        delta.each do |goal|
          _,poss,_,_ = table[goal]

          poss.each do |parent,_,_,_,_|
            g, _ = parent
            if not found.include?(g)
              found << g
              nextdelta << g
            end
          end
        end

        delta = nextdelta
      end

      return found
    end

    def remove_neglookup(goal, frame, table)
      entry = table[goal]
      entry[2] = entry[2].select {|neg| neg != frame}
    end

    def complete(goal, waitings, stack, table, db)
      entry = table[goal]
      answers, _, negs, _ = entry
      entry[1] = []
      entry[2] = []
      entry[3] = true

      empty = answers.empty?

      negs.each do |frame|
        parent, s, goals = frame

        goals.each do |reifiedgoal, _|
          if goal == reifiedgoal
            next
          end

          remove_neglookup(reifiedgoal, frame, table)
        end

        neggoals = goals.select{|r,g| r!=goal}.map{|r,g| g}

        if (empty)
          success(parent, s, [], neggoals, waitings, stack, table, db)
        end
      end
    end


    def success(parent, s, posgoals, neggoals, waitings, stack, table, db)
      if not posgoals.empty?

        p, a = posgoals[0]
        a1 = s.walk(a)
        a2, r, _ = reify(a1)

        poslookup([p, a2], [parent, s, r, posgoals[1..-1], neggoals], waitings, stack, table, db)
        return
      elsif not neggoals.empty?
        reifiedgoals = []
        goals = []

        neggoals.each do |p,a|
          a1 = s.walk(a)
          a2, _, _ = reify(a1)
          reifiedgoals << [p,a2]
          goals << [[p,a2], [p,a]]
        end

        reifiedgoals.each do |g|
          neglookup(g, [parent, s, goals], waitings, stack, table, db)
        end

        return
      end

      goal, subst = parent
      items = subst.items.map {|k,v| [k, s.subst(v)]}
      s1 = Nil.exts(items)

      answer = (0..items.count-1).map {|i| s1.subst([:var, i]) }

      answers, poslookups, neglookups, completed = table[goal]

      if answers.include? answer
        return
      end

      answers << answer

      poslookups.each do |frame|
        waitings << [answer, frame]
      end

    end


    def unify_list(a, b)
      if not a.length == b.length
        return false
      end

      s = Nil

      a.each_index do |i|
        s = s.unify(a[i], b[i])

        if s == false
          return false
        end
      end

      return s
    end


    def call(rule, p, a, waitings, stack, table, db)
      _type, head, posgoals, neggoals = rule

      s = unify_list(a, head)

      if s == false
        return
      end

      s1 = Nil.exts( s.items.select {|k,v| reified(k) } )
      s2 = Nil.exts( s.items.select {|k,v| !reified(k) } )

      return success([[p, a], s1], s2, posgoals, neggoals, waitings, stack, table, db)
    end


    def parse_query(s, mod)
      result = DatalogLexer.tokenize(s)

      if not result[0]
        return result
      end

      ast = DatalogParser.parse_query(result[1])
      if (ast == false)
        return [false, "syntax error in query"]
      end

      query = ast.map do |n,m,f,a|
        [n, [m||mod, f], a]
      end

      [true, query]
    end


    def parse_clauses(s, mod)
      if s == ""
        return [true, []]
      end

      result = DatalogLexer.tokenize(s)

      if not result[0]
        return result
      end

      if (result[1].length === 1)
        return [true, []]
      end

      ast = DatalogParser.parse_clauses(result[1])

      clauses = ast.map do |head, body|
        [head,
         body.map do |n,m,f,a|
           [n, [m||mod, f], a]
         end]
      end

      [true, clauses]
    end


    def build_db(s, mod)
      clauses = parse_clauses(s, mod)

      if not clauses[0]
        return false
      end

      db = {}

      clauses[1].each do |head, body|
        p, a = head
        entry = db[p] || []
        entry << [
                  :rule,
                  a,
                  body.select{|pos,x,y| pos == true}.map{|pos,x,y| [x,y]},
                  body.select{|pos,x,y| pos == false}.map{|pos,x,y| [x,y]}
                 ]
        db[p] = entry
      end

      return db
    end

    class SingleFileContext
      def initialize(s)
        @db = Datalog.build_db(s, "main")
      end

      def [](index)
        m,f = index
        if m == "main"
          return @db.fetch(f, [])
        end

        return []
      end

      def query(s)
        goals = Datalog.parse_query(s, "main")

        if not goals[0]
          return goals
        end

        return Datalog.query(goals[1], self)
      end
    end

  end

  # ctx = Datalog::SingleFileContext.new("c(X,Y): c(X,Z), e(Z,Y). c(X,Y): e(X,Y). e(a,b). e(b,c).")
  # answers = ctx.query("c(X, Y).")

  # ctx = Datalog::SingleFileContext.new("p(a). p(b). q(X,Y): p(X), p(Y), not same(X,Y). same(X,X): p(X).")
  # answers = ctx.query("q(X, Y).")

  # answers.each do |answer|
  #   print answer.X, " ", answer.Y, "\n"
  # end
end
