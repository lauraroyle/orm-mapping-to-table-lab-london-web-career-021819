class Student

      attr_accessor :name, :grade
      attr_reader :id

      def initialize(name, grade, id=nil)
        @id = id
        @name = name
        @grade = grade
      end

#.create_table is a class method because it is not the responsibility of an individual song to create the table it will eventually be saved into. It is the job of the class as a whole to create the table that it is mapped to.

      def self.create_table
            sql =  <<-SQL
          CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
            )
            SQL
          DB[:conn].execute(sql)
      end

      def self.drop_table
            sql =  <<-SQL
          DROP TABLE students;
            SQL
          DB[:conn].execute(sql)
      end


# save is an instance method that saves the attributes describing a given student to the students table in our database.

      def save
        sql =  <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL

          DB[:conn].execute(sql, self.name, self.grade)

          @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end


      def self.create(name:, grade:)
        student = Student.new(name, grade)
        student.save
        student
      end

end


# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]
